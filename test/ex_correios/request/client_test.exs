defmodule ExCorreios.Request.ClientTest do
  use ExUnit.Case

  import ExCorreios.Factory

  @fixture_path "test/support/fixtures"

  alias ExCorreios.Request.{Client, Url}

  describe "Client.get/1" do
    setup do
      bypass = Bypass.open()
      base_url = "http://localhost:#{bypass.port}"

      [base_url: base_url, bypass: bypass]
    end

    @tag :capture_log
    test "returns the success request result", %{base_url: base_url, bypass: bypass} do
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

      url =
        :shipping
        |> build(package: package)
        |> Url.build(base_url)

      Bypass.expect(bypass, fn conn ->
        correios_response = File.read!("#{@fixture_path}/correios_response.xml")

        Plug.Conn.send_resp(conn, 200, correios_response)
      end)

      assert Client.get(url) == expected_response
    end

    @tag :capture_log
    test "returns an error request result", %{
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
  end
end
