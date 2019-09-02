defmodule ExCorreios.Request.ClientTest do
  use ExUnit.Case

  import ExCorreios.Factory

  alias ExCorreios.Request.{Client, Url}
  alias ExCorreios.Shipping.Packages.Package

  describe "Client.get/1" do
    setup do
      bypass = Bypass.open()
      base_url = "http://localhost:#{bypass.port}"

      [base_url: base_url, bypass: bypass]
    end

    test "returns the success request result", %{base_url: base_url, bypass: bypass} do
      response_body = """
      <?xml version=\"1.0\" encoding=\"ISO-8859-1\" ?>\n<Servicos><cServico>
      <Codigo>04510</Codigo><Valor>19,80</Valor><PrazoEntrega>5</PrazoEntrega>
      <ValorSemAdicionais>19,80</ValorSemAdicionais><ValorMaoPropria>0,00</ValorMaoPropria>
      <ValorAvisoRecebimento>0,00</ValorAvisoRecebimento>
      <ValorValorDeclarado>0,00</ValorValorDeclarado><EntregaDomiciliar>S</EntregaDomiciliar>
      <EntregaSabado>N</EntregaSabado><obsFim></obsFim><Erro>0</Erro>
      <MsgErro></MsgErro></cServico></Servicos>
      """

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

      package = Package.build(:package_box, build(:package_item))

      url =
        :shipping
        |> build(package: package)
        |> Url.build(base_url)

      Bypass.expect(bypass, fn conn ->
        Plug.Conn.send_resp(conn, 200, response_body)
      end)

      assert Client.get(url) == expected_response
    end

    test "returns a error request result", %{
      base_url: base_url,
      bypass: bypass
    } do
      error_message = "econnrefused"
      package = Package.build(:package_box, build(:package_item))

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

      assert ExCorreios.calculate(:pac, package, params, base_url: base_url) ==
               {:error, error_message}
    end
  end
end
