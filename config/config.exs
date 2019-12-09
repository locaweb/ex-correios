import Config

config :ex_correios,
  address_url: "https://apps.correios.com.br/SigepMasterJPA/AtendeClienteService/AtendeCliente",
  calculator_url:
    System.get_env("CORREIOS_CALCULATOR_URL") ||
      "http://ws.correios.com.br/calculador/CalcPrecoPrazo.aspx"

import_config "#{Mix.env()}.exs"
