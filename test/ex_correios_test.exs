defmodule ExCorreiosTest do
  use ExUnit.Case

  @fixture_path "test/support/fixtures"

  import ExCorreios.Factory

  describe "ExCorreios.calculate/4" do
    setup do
      bypass = Bypass.open()
      base_url = "http://localhost:#{bypass.port}"

      [base_url: base_url, bypass: bypass]
    end

    @tag :capture_log
    test "returns shipping value calculated based in a service", %{
      base_url: base_url,
      bypass: bypass
    } do
      expected_result =
        {:ok,
         [
           %{
             deadline: 5,
             declared_value: 0.0,
             error_code: "0",
             error_message: "",
             home_delivery: "S",
             manually_entered_value: 0.0,
             notes: "",
             receiving_alert_value: 0.0,
             response_status: "0",
             saturday_delivery: "N",
             service_code: "04510",
             service: :pac,
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
        correios_response = File.read!("#{@fixture_path}/correios_calculator_response.xml")

        Plug.Conn.send_resp(conn, 200, correios_response)
      end)

      assert ExCorreios.calculate([:pac], package, params, base_url: base_url) == expected_result
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

      assert ExCorreios.calculate([:pac], package, params, base_url: base_url) ==
               {:error, "Error to fetching services."}
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

  describe "ExCorreios.find_address/1" do
    test "returns an address by a valid postal code" do
      {:ok, address} = ExCorreios.find_address("35588-000")

      assert address == %{
               city: "Arcos",
               complement: "",
               neighborhood: "Centro",
               state: "MG",
               street: "Avenida Magalhães Pinto",
               zipcode: "35588-000"
             }
    end

    test "returns an error with a reason" do
      assert {:error, %{reason: "CEP NAO ENCONTRADO"}} = ExCorreios.find_address("00000-000")
    end
  end
end
