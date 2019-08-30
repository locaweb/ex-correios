defmodule ExCorreios.Request.ResponseTest do
  use ExUnit.Case

  import ExCorreios.Factory

  alias ExCorreios.Request.{Response, Url}
  alias ExCorreios.Shipping.Packages.Package
  alias ExCorreios.Shipping.Service

  describe "Response.process/1" do
    setup do
      bypass = Bypass.open()
      base_url = "http://localhost:#{bypass.port}"

      [base_url: base_url, bypass: bypass]
    end

    test "returns a processed response", %{base_url: base_url, bypass: bypass} do
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
      shipping = build(:shipping, package: package)
      url = Url.build(shipping, base_url)

      Bypass.expect(bypass, fn conn ->
        Plug.Conn.send_resp(conn, 200, response_body)
      end)

      response = HTTPotion.get(url)

      assert Response.process(response) == expected_response
    end

    test "returns a processed response when has more services", %{
      base_url: base_url,
      bypass: bypass
    } do
      response_body = """
      <?xml version=\"1.0\" encoding=\"ISO-8859-1\" ?>\n<Servicos><cServico>
      <Codigo>04510</Codigo><Valor>19,80</Valor><PrazoEntrega>5</PrazoEntrega>
      <ValorSemAdicionais>19,80</ValorSemAdicionais><ValorMaoPropria>0,00</ValorMaoPropria>
      <ValorAvisoRecebimento>0,00</ValorAvisoRecebimento>
      <ValorValorDeclarado>0,00</ValorValorDeclarado><EntregaDomiciliar>S</EntregaDomiciliar>
      <EntregaSabado>N</EntregaSabado><obsFim></obsFim><Erro>0</Erro><MsgErro></MsgErro></cServico>
      <cServico><Codigo>04014</Codigo><Valor>19,80</Valor><PrazoEntrega>2</PrazoEntrega>
      <ValorSemAdicionais>19,80</ValorSemAdicionais><ValorMaoPropria>0,00</ValorMaoPropria>
      <ValorAvisoRecebimento>0,00</ValorAvisoRecebimento>
      <ValorValorDeclarado>0,00</ValorValorDeclarado><EntregaDomiciliar>S</EntregaDomiciliar>
      <EntregaSabado>S</EntregaSabado><obsFim></obsFim><Erro>0</Erro><MsgErro></MsgErro></cServico>
      </Servicos>
      """

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

      package = Package.build(:package_box, build(:package_item))
      services = Service.get_services([:pac, :sedex])
      shipping = build(:shipping, %{package: package, services: services})
      url = Url.build(shipping, base_url)

      Bypass.expect(bypass, fn conn ->
        Plug.Conn.send_resp(conn, 200, response_body)
      end)

      response = HTTPotion.get(url)

      assert Response.process(response) == expected_response
    end

    test "returns a processed failure response" do
      expected_response = {:error, "req_timedout"}
      response = %HTTPotion.ErrorResponse{message: "req_timedout"}

      assert Response.process(response) == expected_response
    end
  end
end
