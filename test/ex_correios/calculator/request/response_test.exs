defmodule ExCorreios.Calculator.Request.ResponseTest do
  use ExUnit.Case, async: true

  import ExCorreios.Factory

  @fixtures_path "test/support/fixtures/correios/calculator"

  alias ExCorreios.Calculator.Request.{Response, Url}

  describe "Response.process/1" do
    setup do
      bypass = Bypass.open()
      calculator_url = "http://localhost:#{bypass.port}"

      %{bypass: bypass, calculator_url: calculator_url}
    end

    test "returns a processed response", %{bypass: bypass, calculator_url: calculator_url} do
      expected_response =
        {:ok,
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
           value: 19.8,
           value_without_additionals: 19.8
         }}

      url = Url.build(build(:shipping), calculator_url)

      Bypass.expect(bypass, fn conn ->
        correios_response = File.read!("#{@fixtures_path}/success_response.xml")

        Plug.Conn.send_resp(conn, 200, correios_response)
      end)

      response = HTTPoison.get(url)

      assert Response.process(response) == expected_response
    end

    test "returns a processed response with the value with the correct format" do
      response = %HTTPoison.Response{
        body: File.read!("#{@fixtures_path}/success_high_value_response.xml"),
        status_code: 200
      }

      assert Response.process({:ok, response}) ==
               {:ok,
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
                  value: 1070.90,
                  value_without_additionals: 1070.90
                }}
    end

    test "returns an error response", %{bypass: bypass, calculator_url: calculator_url} do
      expected_response =
        {:ok,
         %{
           deadline: 0,
           declared_value: 0.0,
           error: :invalid_origin_postal_code,
           error_code: "-2",
           error_message: "\n       CEP de origem invalido. \n    ",
           home_delivery: "",
           manually_entered_value: 0.0,
           notes: "",
           receiving_alert_value: 0.0,
           response_status: "-2",
           saturday_delivery: "",
           service_code: "04510",
           value: 0.0,
           value_without_additionals: 0.0
         }}

      url = Url.build(build(:shipping), calculator_url)

      Bypass.expect(bypass, fn conn ->
        correios_response = File.read!("#{@fixtures_path}/invalid_origin_response.xml")

        Plug.Conn.send_resp(conn, 200, correios_response)
      end)

      response = HTTPoison.get(url)

      assert Response.process(response) == expected_response
    end

    test "returns request timeout error" do
      response = {:error, %HTTPoison.Error{reason: "req_timedout"}}

      assert Response.process(response) == {:error, "req_timedout"}
    end
  end
end
