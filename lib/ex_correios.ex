defmodule ExCorreios do
  @moduledoc false

  alias ExCorreios.Request.Client
  alias ExCorreios.Shipping.Shipping

  def calculate(services, params) do
    services
    |> Shipping.new(params)
    |> Client.get()
  end
end
