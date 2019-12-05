defmodule ExCorreiosTest do
  use ExUnit.Case, async: true

  import ExCorreios.Factory

  @fixtures_path "test/support/fixtures/correios"

  describe "ExCorreios.calculate/4" do
    setup do
      bypass = Bypass.open()
      calculator_url = "http://localhost:#{bypass.port}"

      %{bypass: bypass, calculator_url: calculator_url}
    end

    @tag :capture_log
    test "returns shipping value calculated based on a service", %{
      bypass: bypass,
      calculator_url: calculator_url
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

      assert ExCorreios.calculate([:pac], package, params, calculator_url: calculator_url) ==
               expected_result
    end

    @tag :capture_log
    test "returns a request error", %{
      bypass: bypass,
      calculator_url: calculator_url
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

      assert ExCorreios.calculate([:pac], package, params, calculator_url: calculator_url) ==
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
end
