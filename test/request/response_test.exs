defmodule ExCorreios.Request.ResponseTest do
  use ExUnit.Case

  import ExCorreios.Factory

  alias ExCorreios.Request.{Response, Url}
  alias ExCorreios.Shipping.Service

  describe "Response.process/1" do
    test "returns a processed response" do
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

      response =
        shipping
        |> Url.build()
        |> HTTPotion.get()

      assert Response.process(response) == expected_response
    end

    test "returns a processed response when has more services" do
      expected_response =
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
             value: 19.8,
             value_without_additionals: 19.8
           },
           %{
             deadline: 2,
             declared_value: 0.0,
             error_code: "0",
             error_message: "",
             home_delivery: "S",
             manually_entered_value: 0.0,
             notes: "",
             receiving_alert_value: 0.0,
             response_status: "0",
             saturday_delivery: "S",
             service_code: "04014",
             value: 19.8,
             value_without_additionals: 19.8
           }
         ]}

      services = Service.get_services([:pac, :sedex])
      shipping = build(:shipping, %{services: services})

      response =
        shipping
        |> Url.build()
        |> HTTPotion.get()

      assert Response.process(response) == expected_response
    end
  end
end
