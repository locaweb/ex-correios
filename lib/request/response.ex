defmodule ExCorreios.Request.Response do
  @moduledoc """
  This module transforms a xml body of a http response into a map or a list of maps.
  """

  import SweetXml, only: [transform_by: 2, sigil_x: 2, xpath: 3]

  @root_path '//Servicos/cServico'
  @shipping_path [
    deadline: ~x"//PrazoEntrega/text()"i,
    declared_value: transform_by(~x"//ValorValorDeclarado/text()"s, &String.to_float/1),
    error_code: ~x"//Erro/text()"s,
    error_message: ~x"//MsgErro/text()"s,
    home_delivery: ~x"//EntregaDomiciliar/text()"s,
    manually_entered_value: transform_by(~x"//ValorMaoPropria/text()"s, &String.to_float/1),
    notes: ~x"//obsFim/text()"s,
    response_status: ~x"//Erro/text()"s,
    receiving_alert_value: transform_by(~x"//ValorAvisoRecebimento/text()"s, &String.to_float/1),
    saturday_delivery: ~x"//EntregaSabado/text()"s,
    service_code: ~x"//Codigo/text()"s,
    value: transform_by(~x"//Valor/text()"s, &String.to_float/1),
    value_without_additionals: transform_by(~x"//ValorSemAdicionais/text()"s, &String.to_float/1)
  ]

  @spec process(%HTTPotion.Response{}) :: {:ok, map()} | {:ok, list(struct())}
  def process(%HTTPotion.Response{status_code: 200, body: body}), do: {:ok, parser(body)}

  @spec process(%HTTPotion.ErrorResponse{}) :: {:error, String.t()}
  def process(%HTTPotion.ErrorResponse{message: reason}), do: {:error, reason}

  defp parser(body) do
    case xpath(body, %SweetXpath{path: @root_path, is_list: true}, @shipping_path) do
      [value] -> value
      values -> values
    end
  end
end
