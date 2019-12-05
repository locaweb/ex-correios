defmodule ExCorreios.Address.Request.BodyTest do
  use ExUnit.Case, async: true

  alias ExCorreios.Address.Request.Body

  describe "Body.build/1" do
    test "returns the request body with the given postal code" do
      postal_code = "35588-000"

      assert Body.build(postal_code) ==
               """
               <?xml version="1.0" encoding="UTF-8"?>
               <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:cli="http://cliente.bean.master.sigep.bsb.correios.com.br/">
                 <soapenv:Header />
                 <soapenv:Body>
                   <cli:consultaCEP>
                     <cep>#{postal_code}</cep>
                   </cli:consultaCEP>
                 </soapenv:Body>
               </soapenv:Envelope>
               """
    end
  end
end
