defmodule ExCorreios.Request.Url do
  @moduledoc false

  @default_return "xml"

  @spec build(struct()) :: String.t()
  def build(shipping), do: "#{base_url()}?#{format_params(shipping)}"

  defp format_params(%{package: package} = shipping) do
    "nCdEmpresa=#{shipping.enterprise}&" <>
      "sDsSenha=#{shipping.password}&" <>
      "nCdServico=#{format_services(shipping.services)}&" <>
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

  defp base_url, do: Application.get_env(:ex_correios, :base_url)

  defp format_services(services) when is_list(services) do
    services
    |> Enum.map(fn {_k, v} -> v.code end)
    |> Enum.join(",")
  end

  defp format_services(service), do: service.code

  defp format_boolean(true), do: "S"
  defp format_boolean(false), do: "N"
end
