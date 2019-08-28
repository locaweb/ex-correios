defmodule ExCorreios.Request.Client do
  @moduledoc """
  This module provides a http interface to communicate with Correios API.
  """

  alias ExCorreios.Request.Response

  @spec get(String.t()) :: {:ok, map()} | {:ok, list(struct)} | {:error, String.t()}
  def get(url) do
    url
    |> HTTPotion.get()
    |> Response.process()
  end
end
