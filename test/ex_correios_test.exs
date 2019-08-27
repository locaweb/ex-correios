defmodule ExCorreiosTest do
  use ExUnit.Case
  doctest ExCorreios

  describe "ExCorreios.calculate/2" do
    test "returns shipping value calculated based in a service" do
      expected_result =
        {:ok,
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
           value: 19.8,
           value_without_additionals: 19.8
         }}

      params = %{
        diameter: 40,
        format: :package_box,
        width: 11.0,
        height: 2.0,
        length: 16.0,
        weight: 0.3,
        destination: "05724005",
        origin: "08720030",
        enterprise: "",
        password: "",
        receiving_alert: false,
        declared_value: 0,
        manually_entered: false
      }

      assert ExCorreios.calculate(:pac, params) == expected_result
    end
  end
end
