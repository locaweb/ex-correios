defmodule ExCorreios.Shipping.Shipping do
  @moduledoc """
  This module provides a shipping struct.
  """

  @enforce_keys [:destination, :package, :origin, :services]

  defstruct declared_value: 0,
            destination: nil,
            enterprise: nil,
            manually_entered: false,
            origin: nil,
            package: nil,
            password: nil,
            receiving_alert: false,
            services: nil

  @type t :: %__MODULE__{
          declared_value: String.t(),
          destination: String.t(),
          enterprise: String.t(),
          manually_entered: String.t(),
          origin: String.t(),
          package: struct(),
          password: String.t(),
          receiving_alert: String.t(),
          services: List.t()
        }

  alias ExCorreios.Shipping.Packages.Package
  alias ExCorreios.Shipping.Service

  @spec new(list(atom), %Package{}, map()) :: %__MODULE__{}
  def new(service_keys, package, params) do
    services = Service.get_services(service_keys)

    shipping_params =
      params
      |> Map.put(:services, services)
      |> Map.put(:package, package)

    struct(__MODULE__, shipping_params)
  end
end
