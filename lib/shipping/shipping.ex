defmodule ExCorreios.Shipping.Shipping do
  @moduledoc false

  @enforce_keys [:destination, :package, :origin, :services]

  defstruct [
    :declared_value,
    :destination,
    :enterprise,
    :manually_entered,
    :origin,
    :package,
    :password,
    :receiving_alert,
    :services
  ]

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

  @package_keys [:format, :height, :length, :weight, :width]
  @default_values %{declared_value: 0, manually_entered: false, receiving_alert: false}

  @spec new(atom() | list(), map()) :: %__MODULE__{}
  def new(service_keys, params) do
    package = build_package(params)
    services = get_services(service_keys)

    shipping_params =
      @default_values
      |> Map.merge(params)
      |> Map.drop(@package_keys)
      |> Map.put(:services, services)
      |> Map.put(:package, package)

    struct!(__MODULE__, shipping_params)
  end

  defp build_package(shipping_params) do
    shipping_params
    |> Map.take(@package_keys)
    |> Package.new()
  end

  defp get_services(services) when is_list(services), do: Service.get_services(services)
  defp get_services(service), do: Service.get_service(service)
end
