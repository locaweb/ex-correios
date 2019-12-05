defmodule ExCorreios.AddressTest do
  use ExUnit.Case, async: true

  alias ExCorreios.Address

  @fixtures_path "test/support/fixtures/correios/address"

  setup do
    bypass = Bypass.open()
    address_url = "http://localhost:#{bypass.port}"

    %{address_url: address_url, bypass: bypass}
  end

  describe "Address.find/2" do
    @tag :capture_log
    test "returns an address when the request response is valid", %{
      address_url: address_url,
      bypass: bypass
    } do
      Bypass.expect(bypass, fn conn ->
        response = File.read!("#{@fixtures_path}/success_response.xml")

        Plug.Conn.send_resp(conn, 200, response)
      end)

      assert Address.find("37200-001", address_url: address_url) ==
               {:ok,
                %Address{
                  city: "Lavras",
                  complement: "",
                  neighborhood: "Centro",
                  postal_code: "37200001",
                  state: "MG",
                  street: "Rua Gustavo Pena"
                }}
    end

    @tag :capture_log
    test "returns an error when the request response has the reason of the error", %{
      address_url: address_url,
      bypass: bypass
    } do
      Bypass.expect(bypass, fn conn ->
        response = File.read!("#{@fixtures_path}/invalid_response.xml")

        Plug.Conn.send_resp(conn, 500, response)
      end)

      assert Address.find("00000-000", address_url: address_url) == {:error, :invalid_postal_code}
    end

    @tag :capture_log
    test "returns an error when the request response fails", %{
      address_url: address_url,
      bypass: bypass
    } do
      Bypass.down(bypass)

      assert Address.find("00000-000", address_url: address_url) == {:error, :econnrefused}
    end
  end
end
