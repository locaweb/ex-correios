defmodule ExCorreios.Request.Url do
  @moduledoc """
  This module builds an url based on shipping informations.
  """

  @default_return "xml"

  alias ExCorreios.Shipping.Shipping

  @spec build(%Shipping{}, String.t()) :: String.t()
  def build(shipping, base_url \\ nil), do: "#{base_url(base_url)}?#{format_params(shipping)}"

  defp format_params(%{package: package} = shipping) do
    "nCdEmpresa=#{shipping.enterprise}&" <>
      "sDsSenha=#{shipping.password}&" <>
      "nCdServico=#{shipping.service.code}&" <>
      "sCepOrigem=#{shipping.origin}&" <>
      "sCepDestino=#{shipping.destination}&" <>
      "nVlPeso=#{package.weight}&" <>
      "nCdFormato=#{package.format}&" <>
      "nVlComprimento=#{package.length}&" <>
      "nVlAltura=#{package.height}&" <>
      "nVlLargura=#{package.width}&" <>
      "nVlDiametro=#{package.diameter}&" <>
      "nCdMaoPropria=#{format_boolean(shipping.manually_entered)}&" <>
      "nCdMaoPropria=#{shipping.manually_entered}&" <>
      "nVlValorDeclarado=#{shipping.declared_value}&" <>
      "sCdAvisoRecebimento=#{format_boolean(shipping.receiving_alert)}&" <>
      "sCdAvisoRecebimento=#{shipping.receiving_alert}&" <>
      "StrRetorno=#{@default_return}"
  end

  defp base_url(nil), do: Application.get_env(:ex_correios, :base_url)
  defp base_url(url), do: url

  defp format_boolean(true), do: "S"
  defp format_boolean(false), do: "N"
end
