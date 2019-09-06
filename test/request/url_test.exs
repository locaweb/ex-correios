defmodule ExCorreios.Request.UrlTest do
  use ExUnit.Case

  import ExCorreios.Factory

  alias ExCorreios.Request.Url
  alias ExCorreios.Shipping.Service

  describe "Url.build/1" do
    test "returns a formatted" do
      expected_url =
        "http://ws.correios.com.br/calculador/CalcPrecoPrazo.aspx?" <>
          "nCdEmpresa=&sDsSenha=&nCdServico=04510,04014&sCepOrigem=08720030&" <>
          "sCepDestino=05724005&nVlPeso=0.3&nCdFormato=1&nVlComprimento=16.0&" <>
          "nVlAltura=2.0&nVlLargura=11.0&nVlDiametro=40&nCdMaoPropria=N&nCdMaoPropria=false&" <>
          "nVlValorDeclarado=0&sCdAvisoRecebimento=N&sCdAvisoRecebimento=false&StrRetorno=xml"

      package = build(:package)
      services = Service.get_services([:pac, :sedex])
      shipping = build(:shipping, %{package: package, services: services})

      assert Url.build(shipping) == expected_url
    end
  end
end
