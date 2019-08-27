defmodule ExCorreios.Request.Client do
  @moduledoc false

  alias ExCorreios.Request.Response

  @spec get(String.t()) :: tuple()
  def get(url) do
    url
    |> HTTPotion.get()
    |> Response.process()
  end
end
