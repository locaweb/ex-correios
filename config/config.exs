import Config

config :ex_correios,
  calculator_url:
    System.get_env("CORREIOS_CALCULATOR_URL") ||
      "http://ws.correios.com.br/calculador/CalcPrecoPrazo.aspx"

config :correios_cep, client: Correios.CEP.Client

import_config "#{Mix.env()}.exs"
