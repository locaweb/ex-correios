defmodule ExCorreios.CalculatorTest do
  use ExUnit.Case, async: true

  import ExCorreios.Factory

  alias ExCorreios.Calculator

  @fixture_path "test/support/fixtures"

  describe "Calculator.calculate/4" do
    setup do
      bypass = Bypass.open()
      calculator_url = "http://localhost:#{bypass.port}"

      %{bypass: bypass, calculator_url: calculator_url}
    end

    @tag :capture_log
    test "returns shipping value calculated based in a service", %{
      bypass: bypass,
      calculator_url: calculator_url
    } do
      package = build(:package)
      params = %{destination: "05724005", origin: "08720030"}

      Bypass.expect(bypass, fn conn ->
        correios_response = File.read!("#{@fixture_path}/correios_calculator_response.xml")

        Plug.Conn.send_resp(conn, 200, correios_response)
      end)

      assert Calculator.calculate([:pac], package, params, calculator_url: calculator_url) ==
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
    end

    @tag :capture_log
    test "returns a request error", %{bypass: bypass, calculator_url: calculator_url} do
      package = build(:package)
      params = %{destination: "05724005", origin: "08720030"}

      Bypass.down(bypass)

      assert Calculator.calculate([:pac], package, params, calculator_url: calculator_url) ==
               {:error, "Error fetching services."}
    end

    test "returns a params error" do
      package = build(:package)
      params = %{destination: "05724005", origin: "08720030"}

      assert Calculator.calculate([], package, params) == {:error, :empty_service_list}
    end
  end
end
