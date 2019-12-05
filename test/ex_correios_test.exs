defmodule ExCorreiosTest do
  use ExUnit.Case, async: true

  import ExCorreios.Factory

  alias ExCorreios.Address

  @fixtures_path "test/support/fixtures/correios"

  setup do
    bypass = Bypass.open()
    base_url = "http://localhost:#{bypass.port}"

    %{base_url: base_url, bypass: bypass}
  end

  describe "ExCorreios.calculate/4" do
    @tag :capture_log
    test "returns shipping value calculated based on a service", %{
      base_url: base_url,
      bypass: bypass
    } do
      expected_result =
        {:ok,
         [
           %{
             deadline: 5,
             declared_value: 0.0,
             error: nil,
             error_code: "0",
             error_message: "",
             home_delivery: "S",
             manually_entered_value: 0.0,
             notes: "",
             receiving_alert_value: 0.0,
             response_status: "0",
             saturday_delivery: "N",
             service_code: "04510",
             name: "PAC",
             value: 19.8,
             value_without_additionals: 19.8
           }
         ]}

      package = build(:package)

      params = %{
        destination: "05724005",
        origin: "08720030",
        enterprise: "",
        password: "",
        receiving_alert: false,
        declared_value: 0,
        manually_entered: false
      }

      Bypass.expect(bypass, fn conn ->
        correios_response = File.read!("#{@fixtures_path}/calculator/success_response.xml")

        Plug.Conn.send_resp(conn, 200, correios_response)
      end)

      assert ExCorreios.calculate([:pac], package, params, calculator_url: base_url) ==
               expected_result
    end

    @tag :capture_log
    test "returns a request error", %{
      base_url: base_url,
      bypass: bypass
    } do
      package = build(:package)

      params = %{
        destination: "05724005",
        origin: "08720030",
        enterprise: "",
        password: "",
        receiving_alert: false,
        declared_value: 0,
        manually_entered: false
      }

      Bypass.down(bypass)

      assert ExCorreios.calculate([:pac], package, params, calculator_url: base_url) ==
               {:error, "Error fetching services."}
    end

    @tag :capture_log
    test "returns a params error" do
      package = build(:package)

      params = %{
        destination: "05724005",
        origin: "08720030",
        enterprise: "",
        password: "",
        receiving_alert: false,
        declared_value: 0,
        manually_entered: false
      }

      assert ExCorreios.calculate([], package, params) == {:error, :empty_service_list}
    end
  end

  describe "ExCorreios.find_address/2" do
    test "returns an address by a valid postal code", %{base_url: base_url, bypass: bypass} do
      Bypass.expect(bypass, fn conn ->
        response = File.read!("#{@fixtures_path}/address/success_response.xml")

        Plug.Conn.send_resp(conn, 200, response)
      end)

      assert ExCorreios.find_address("37200-001", address_url: base_url) ==
               {:ok,
                %Address{
                  city: "Lavras",
                  complement: "",
                  district: "Centro",
                  postal_code: "37200001",
                  state: "MG",
                  street: "Rua Gustavo Pena"
                }}
    end

    test "returns an error with a reason", %{base_url: base_url, bypass: bypass} do
      Bypass.expect(bypass, fn conn ->
        response = File.read!("#{@fixtures_path}/address/not_found_response.xml")

        Plug.Conn.send_resp(conn, 500, response)
      end)

      assert ExCorreios.find_address("00000-321", address_url: base_url) ==
               {:error, :postal_code_not_found}
    end
  end
end
