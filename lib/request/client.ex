defmodule ExCorreios.Request.Client do
  @moduledoc """
  This module provides an http interface to communicate with Correios API.
  """

  require Logger

  alias ExCorreios.Request.Response

  @spec get(String.t()) :: {:ok, list(struct)} | {:error, String.t()}
  def get(url, opts \\ []) do
    url
    |> log_request()
    |> HTTPoison.get(opts)
    |> Response.process()
  end

  defp log_request(url) do
    Logger.info(fn -> "Processing with #{__MODULE__}\n  URL: #{url}" end)

    url
  end
end
