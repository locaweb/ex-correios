defmodule Correios.Request.Client do
  @moduledoc false

  alias Correios.Request.{Response, Url}

  def get(shipping) do
    shipping
    |> Url.build
    |> HTTPotion.get()
    |> Response.process
  end
end
