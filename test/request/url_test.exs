defmodule ExCorreios.Request.UrlTest do
  use ExUnit.Case

  import ExCorreios.Factory

  alias ExCorreios.Request.Url
  alias ExCorreios.Shipping.Packages.Package
  alias ExCorreios.Shipping.Service

  describe "Url.build/1" do
    test "returns a formatted url" do
      expected_url =
        "http://ws.correios.com.br/calculador/CalcPrecoPrazo.aspx?" <>
          "nCdEmpresa=&sDsSenha=&nCdServico=04510&sCepOrigem=08720030&" <>
          "sCepDestino=05724005&nVlPeso=0.3&nCdFormato=1&nVlComprimento=16.0&" <>
          "nVlAltura=2.0&nVlLargura=11.0&nVlDiametro=40&nCdMaoPropria=N&nCdMaoPropria=false&" <>
          "nVlValorDeclarado=0&sCdAvisoRecebimento=N&sCdAvisoRecebimento=false&StrRetorno=xml"

      package = Package.build(:package_box, build(:package_item))
      shipping = build(:shipping, package: package)

      assert Url.build(shipping) == expected_url
    end

    test "returns a formatted url when the shipping has more services than one" do
      expected_url =
        "http://ws.correios.com.br/calculador/CalcPrecoPrazo.aspx?" <>
          "nCdEmpresa=&sDsSenha=&nCdServico=04510,04014&sCepOrigem=08720030&" <>
          "sCepDestino=05724005&nVlPeso=0.3&nCdFormato=1&nVlComprimento=16.0&" <>
          "nVlAltura=2.0&nVlLargura=11.0&nVlDiametro=40&nCdMaoPropria=N&nCdMaoPropria=false&" <>
          "nVlValorDeclarado=0&sCdAvisoRecebimento=N&sCdAvisoRecebimento=false&StrRetorno=xml"

      package = Package.build(:package_box, build(:package_item))
      services = Service.get_services([:pac, :sedex])
      shipping = build(:shipping, %{package: package, services: services})

      assert Url.build(shipping) == expected_url
    end
  end
end
