use Mix.Config

config :ex_correios,
  base_url:
    System.get_env("CORREIOS_URL") || "http://ws.correios.com.br/calculador/CalcPrecoPrazo.aspx"
