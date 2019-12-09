defmodule ExCorreios.Address.Request.Body do
  @moduledoc "This module builds the address request body."

  @spec build(String.t()) :: String.t()
  def build(postal_code) do
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
