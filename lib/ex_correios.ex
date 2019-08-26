defmodule ExCorreios do
  @moduledoc false

  alias ExCorreios.Request.Client
  alias ExCorreios.Shipping.Packages.{Format, Package}
  alias ExCorreios.Shipping.{Service, Shipping}

  @package_keys [:format, :height, :length, :weight, :width]
  @default_values %{
    declared_value: 0,
    manually_entered: false,
    receiving_alert: false,
    diameter: 0.0,
    format: :package_box,
    height: 0.0,
    length: 0.0,
    weight: 0.0,
    width: 0.0
  }

  def calculate(services, params) do
    services
    |> get_services()
    |> build_shipping(params)
    |> Client.get()
  end

  defp build_shipping(services, params) do
    package = build_package(params)

    shipping_params =
      @default_values
      |> Map.merge(params)
      |> Map.delete(@package_keys)
      |> Map.put(:services, services)
      |> Map.put(:package, package)

    struct(Shipping, shipping_params)
  end

  defp build_package(shipping_params) do
    package_params =
      shipping_params
      |> Map.take(@package_keys)
      |> Map.put(:format, Format.get(shipping_params.format))

    struct(Package, package_params)
  end

  defp get_services(services) when is_list(services), do: Service.get_services(services)
  defp get_services(service), do: Service.get_service(service)
end
