defmodule ExCorreios.Calculator.Request.UrlTest do
  use ExUnit.Case, async: true

  import ExCorreios.Factory

  alias ExCorreios.Calculator.Request.Url
  alias ExCorreios.Calculator.Shipping.Service

  describe "Url.build/1" do
    test "returns a formatted" do
      expected_url =
        "http://ws.correios.com.br/calculador/CalcPrecoPrazo.aspx?" <>
          "nCdEmpresa=&sDsSenha=&nCdServico=04014&sCepOrigem=08720030&" <>
          "sCepDestino=05724005&nVlPeso=0.3&nCdFormato=1&nVlComprimento=16.0&" <>
          "nVlAltura=2.0&nVlLargura=11.0&nVlDiametro=40&nCdMaoPropria=N&nCdMaoPropria=false&" <>
          "nVlValorDeclarado=0&sCdAvisoRecebimento=N&sCdAvisoRecebimento=false&StrRetorno=xml"

      package = build(:package)
      service = Service.get_service(:sedex)
      shipping = build(:shipping, %{package: package, service: service})

      assert Url.build(shipping) == expected_url
    end
  end
end
