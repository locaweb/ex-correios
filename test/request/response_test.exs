defmodule ExCorreios.Request.ResponseTest do
  use ExUnit.Case

  import ExCorreios.Factory

  @fixture_path "test/support/fixtures"

  alias ExCorreios.Request.{Response, Url}
  alias ExCorreios.Shipping.Service

  describe "Response.process/1" do
    setup do
      bypass = Bypass.open()
      base_url = "http://localhost:#{bypass.port}"

      [base_url: base_url, bypass: bypass]
    end

    test "returns a processed response", %{base_url: base_url, bypass: bypass} do
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
           }
         ]}

      package = build(:package)
      shipping = build(:shipping, package: package)
      url = Url.build(shipping, base_url)

      Bypass.expect(bypass, fn conn ->
        correios_response = File.read!("#{@fixture_path}/correios_response.xml")

        Plug.Conn.send_resp(conn, 200, correios_response)
      end)

      response = HTTPoison.get(url)

      assert Response.process(response) == expected_response
    end

    test "returns a processed response when has more services", %{
      base_url: base_url,
      bypass: bypass
    } do
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

      package = build(:package)
      services = Service.get_services([:pac, :sedex])
      shipping = build(:shipping, %{package: package, services: services})
      url = Url.build(shipping, base_url)

      Bypass.expect(bypass, fn conn ->
        correios_response = File.read!("#{@fixture_path}/correios_with_more_services_response.xml")

        Plug.Conn.send_resp(conn, 200, correios_response)
      end)

      response = HTTPoison.get(url)

      assert Response.process(response) == expected_response
    end

    test "returns a processed failure response" do
      expected_response = {:error, "req_timedout"}
      response = {:error, %HTTPoison.Error{reason: "req_timedout"}}

      assert Response.process(response) == expected_response
    end
  end
end
