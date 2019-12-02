defmodule ExCorreios.Request.ClientTest do
  use ExUnit.Case, async: true

  import ExCorreios.Factory

  @fixture_path "test/support/fixtures"

  alias ExCorreios.Calculator.Request.Url
  alias ExCorreios.Request.Client

  describe "Client.get/1" do
    setup do
      bypass = Bypass.open()
      calculator_url = "http://localhost:#{bypass.port}"

      [bypass: bypass, calculator_url: calculator_url]
    end

    @tag :capture_log
    test "returns a success request result", %{bypass: bypass, calculator_url: calculator_url} do
      correios_response = File.read!("#{@fixture_path}/correios_calculator_response.xml")
      package = build(:package)

      url =
        :shipping
        |> build(package: package)
        |> Url.build(calculator_url)

      Bypass.expect(bypass, fn conn ->
        Plug.Conn.send_resp(conn, 200, correios_response)
      end)

      assert {:ok, %{status_code: 200, body: ^correios_response}} = Client.get(url)
    end

    @tag :capture_log
    test "returns an error request", %{bypass: bypass, calculator_url: calculator_url} do
      package = build(:package)

      url =
        :shipping
        |> build(package: package)
        |> Url.build(calculator_url)

      Bypass.expect(bypass, fn conn ->
        Plug.Conn.send_resp(conn, 400, "Bad gateway")
      end)

      assert {:ok, %{status_code: 400, body: "Bad gateway"}} = Client.get(url)
    end
  end
end
