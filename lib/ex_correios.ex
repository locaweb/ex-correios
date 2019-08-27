defmodule ExCorreios do
  @moduledoc false

  alias ExCorreios.Request.Client
  alias ExCorreios.Shipping.Shipping

  @spec calculate(atom() | list(), map()) :: tuple()
  def calculate(services, params) do
    services
    |> Shipping.new(params)
    |> Client.get()
  end
end
