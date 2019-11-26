defmodule ExCorreios.Calculator.Request.ResponseTest do
  use ExUnit.Case, async: true

  import ExCorreios.Factory

  @fixture_path "test/support/fixtures"

  alias ExCorreios.Calculator.Request.{Response, Url}

  describe "Response.process/1" do
    setup do
      bypass = Bypass.open()
      calculator_url = "http://localhost:#{bypass.port}"

      [calculator_url: calculator_url, bypass: bypass]
    end

    test "returns a processed response", %{calculator_url: calculator_url, bypass: bypass} do
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

      package = build(:package)
      shipping = build(:shipping, package: package)
      url = Url.build(shipping, calculator_url)

      Bypass.expect(bypass, fn conn ->
        correios_response = File.read!("#{@fixture_path}/correios_calculator_response.xml")

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
