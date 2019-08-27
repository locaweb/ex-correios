defmodule ExCorreios.Request.ClientTest do
  use ExUnit.Case

  import ExCorreios.Factory

  alias ExCorreios.Request.Client

  describe "Client.get/1" do
    test "returns the success request result" do
      expected_response =
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

      shipping = build(:shipping)

      assert Client.get(shipping) == expected_response
    end

    test "returns the failure request result" do
    end
  end
end
