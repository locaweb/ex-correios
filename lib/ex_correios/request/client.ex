defmodule ExCorreios.Request.Client do
  @moduledoc """
  This module provides an http interface to communicate with Correios API.
  """

  require Logger

  alias HTTPoison.{Error, Response}

  @spec get(String.t(), keyword()) :: {:ok, Response.t()} | {:error, Error.t()}
  def get(url, opts \\ []) do
    url
    |> log_request()
    |> HTTPoison.get([], allowed_opts(opts))
  end

  @spec post(String.t(), String.t(), keyword()) :: {:ok, Response.t()} | {:error, Error.t()}
  def post(url, body, opts \\ []) do
    url
    |> log_request()
    |> HTTPoison.post(body, [{"Content-Type", "text/xml; charset=utf-8"}], allowed_opts(opts))
  end

  defp log_request(url) do
    Logger.info(fn -> "Processing with #{__MODULE__}\n  URL: #{url}" end)

    url
  end

  defp allowed_opts(opts) do
    opts = Keyword.take(opts, [:recv_timeout, :timeout])

    case Application.get_env(:ex_correios, :proxy) do
      {host, port} when is_binary(host) and is_binary(port) ->
        Keyword.put(opts, :proxy, {host, String.to_integer(port)})

      _ ->
        opts
    end
  end
end
