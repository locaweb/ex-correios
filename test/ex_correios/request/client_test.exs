defmodule ExCorreios.Request.ClientTest do
  use ExUnit.Case, async: true

  import ExCorreios.Factory

  @fixtures_path "test/support/fixtures/correios"

  alias ExCorreios.Address.Request.Body
  alias ExCorreios.Calculator.Request.Url
  alias ExCorreios.Request.Client

  setup do
    bypass = Bypass.open()
    base_url = "http://localhost:#{bypass.port}"

    %{base_url: base_url, bypass: bypass}
  end

  describe "Client.get/1" do
    @tag :capture_log
    test "returns a success request result", %{base_url: base_url, bypass: bypass} do
      correios_response = File.read!("#{@fixtures_path}/calculator/success_response.xml")
      package = build(:package)

      url =
        :shipping
        |> build(package: package)
        |> Url.build(base_url)

      Bypass.expect(bypass, fn conn ->
        Plug.Conn.send_resp(conn, 200, correios_response)
      end)

      assert {:ok, %{status_code: 200, body: ^correios_response}} = Client.get(url)
    end

    @tag :capture_log
    test "returns an error request", %{base_url: base_url, bypass: bypass} do
      package = build(:package)

      url =
        :shipping
        |> build(package: package)
        |> Url.build(base_url)

      Bypass.expect(bypass, fn conn ->
        Plug.Conn.send_resp(conn, 400, "Bad gateway")
      end)

      assert {:ok, %{status_code: 400, body: "Bad gateway"}} = Client.get(url)
    end
  end

  describe "Client.post/2" do
    @tag :capture_log
    test "returns a success request result", %{base_url: base_url, bypass: bypass} do
      correios_address_response = File.read!("#{@fixtures_path}/address/success_response.xml")

      Bypass.expect(bypass, fn conn ->
        Plug.Conn.send_resp(conn, 200, correios_address_response)
      end)

      assert {:ok, %{status_code: 200, body: ^correios_address_response}} =
               Client.post(base_url, Body.build("37200-001"))
    end

    @tag :capture_log
    test "returns an error", %{base_url: base_url, bypass: bypass} do
      Bypass.down(bypass)

      assert Client.post(base_url, Body.build("37200-001")) ==
               {:error,
                %HTTPoison.Error{
                  id: nil,
                  reason: :econnrefused
                }}
    end
  end
end
