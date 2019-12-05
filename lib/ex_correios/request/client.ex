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
    |> HTTPoison.get([], opts)
  end

  @spec post(String.t(), String.t(), keyword()) :: {:ok, Response.t()} | {:error, Error.t()}
  def post(url, body, opts \\ []) do
    url
    |> log_request()
    |> HTTPoison.post(body, opts)
  end

  defp log_request(url) do
    Logger.info(fn -> "Processing with #{__MODULE__}\n  URL: #{url}" end)

    url
  end
end
