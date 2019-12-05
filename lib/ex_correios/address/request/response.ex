defmodule ExCorreios.Address.Request.Response do
  @moduledoc "This module parses the address request response."

  import SweetXml, only: [sigil_x: 2, xpath: 2, xpath: 3]

  @invalid "CEP INVÁLIDO"
  @not_found "CEP NAO ENCONTRADO"
  @parse_root_path '//return'

  @typep response :: {:ok, %HTTPoison.Response{}} | {:error, %HTTPoison.Error{}}

  @spec process(response()) :: {:ok, map()} | {:error, atom()}
  def process({:ok, %HTTPoison.Response{status_code: 200, body: body}}), do: {:ok, parse(body)}
  def process({:ok, %HTTPoison.Response{body: body}}), do: {:error, parse_error(body)}
  def process({:error, %HTTPoison.Error{reason: reason}}), do: {:error, reason}

  defp parse(body), do: xpath(body, %SweetXpath{path: @parse_root_path}, address_path())

  defp address_path do
    [
      city: ~x"//cidade/text()"s,
      complement: ~x"//complemento/text()"s,
      neighborhood: ~x"//bairro/text()"s,
      postal_code: ~x"//cep/text()"s,
      state: ~x"//estado/text()"s,
      street: ~x"//end/text()"s
    ]
  end

  defp parse_error(body), do: body |> xpath(~x"//faultstring/text()"s) |> format_error()

  defp format_error(@invalid), do: :invalid_postal_code
  defp format_error(@not_found), do: :postal_code_not_found
  defp format_error(_), do: :unexpected_error
end
