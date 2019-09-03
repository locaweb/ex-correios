defmodule ExCorreios do
  @moduledoc """
  This module provides a function to calculate shipping based on one or more services.
  """

  alias ExCorreios.Request.{Client, Url}
  alias ExCorreios.Shipping.Packages.Package
  alias ExCorreios.Shipping.Shipping

  @doc """
  Calculate shipping based on one or more services.

  ## Examples

      iex> package_item = ExCorreios.Shipping.Packages.PackageItem.new(%{
      ...>  diameter: 40,
      ...>  width: 11.0,
      ...>  height: 2.0,
      ...>  length: 16.0,
      ...>  weight: 0.9,
      ...> })
      iex> package = ExCorreios.Shipping.Packages.Package.build(:package_box, package_item)
      iex> shipping_params = %{
      ...>  destination: "05724005",
      ...>  origin: "08720030",
      ...>  enterprise: "",
      ...>  password: "",
      ...>  receiving_alert: false,
      ...>  declared_value: 0,
      ...>  manually_entered: false
      ...> }
      iex> ExCorreios.calculate([:pac, :sedex], package, shipping_params)
      {:ok,
        [
          %{
            deadline: 5,
            declared_value: 0.0,
            error_code: "0",
            error_message: "",
            home_delivery: "S",
            manually_entered_value: 0.0,
            notes: "",
            receiving_alert_value: 0.0,
            response_status: "0",
            saturday_delivery: "N",
            service_code: "04510",
            value: 19.8,
            value_without_additionals: 19.8
          },
          %{
            deadline: 2,
            declared_value: 0.0,
            error_code: "0",
            error_message: "",
            home_delivery: "S",
            manually_entered_value: 0.0,
            notes: "",
            receiving_alert_value: 0.0,
            response_status: "0",
            saturday_delivery: "S",
            service_code: "04014",
            value: 21.2,
            value_without_additionals: 21.2
          }
        ]
      }
  """
  @spec calculate(list(atom), %Package{}, map(), String.t()) ::
          {:ok, list(map)} | {:error, String.t()}
  def calculate(services, package, params, opts \\ []) do
    base_url = Keyword.get(opts, :base_url)

    services
    |> Shipping.new(package, params)
    |> Url.build(base_url)
    |> Client.get()
  end
end
