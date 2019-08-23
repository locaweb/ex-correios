defmodule ExCorreios.Request.Client do
  @moduledoc false

  alias ExCorreios.Request.{Response, Url}

  def get(shipping) do
    shipping
    |> Url.build
    |> HTTPotion.get()
    |> Response.process
  end
end
