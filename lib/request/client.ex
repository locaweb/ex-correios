defmodule ExCorreios.Request.Client do
  @moduledoc false

  alias ExCorreios.Request.{Response, Url}

  @spec get(struct()) :: tuple()
  def get(shipping) do
    shipping
    |> Url.build()
    |> HTTPotion.get()
    |> Response.process()
  end
end
