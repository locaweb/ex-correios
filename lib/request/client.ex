defmodule ExCorreios.Request.Client do
  @moduledoc """
  This module provides a http interface to communicate with Correios API.
  """
  require Logger

  alias ExCorreios.Request.Response

  @spec get(String.t()) :: {:ok, map()} | {:ok, list(struct)} | {:error, String.t()}
  def get(url) do
    url
    |> log_request()
    |> HTTPotion.get()
    |> Response.process()
  end

  defp log_request(url) do
    Logger.info(fn -> "Processing with #{__MODULE__}\n  URL: #{url}" end)

    url
  end
end
