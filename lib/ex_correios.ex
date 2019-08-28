defmodule ExCorreios do
  @moduledoc false

  alias ExCorreios.Request.{Client, Url}
  alias ExCorreios.Shipping.Shipping

  @spec calculate(atom() | list(), map(), String.t()) ::
          {:ok, map()} | {:ok, list(map)} | {:error, String.t()}
  def calculate(services, params, base_url \\ nil) do
    services
    |> Shipping.new(params)
    |> Url.build(base_url)
    |> Client.get()
  end
end
