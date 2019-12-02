defmodule ExCorreios do
  @moduledoc """
  This module provides a function to calculate shipping based on one or more services.
  """

  alias Correios.CEP
  alias ExCorreios.Calculator
  alias ExCorreios.Calculator.Shipping.Package

  @typep address :: %{
           city: String.t(),
           complement: String.t(),
           neighborhood: String.t(),
           state: String.t(),
           street: String.t(),
           zipcode: String.t()
         }

  @doc """
  Calculate shipping based on one or more services.

  ## Examples

      iex> dimensions = [%{diameter: 40, width: 11.0, height: 2.0, length: 16.0, weight: 0.9}]
      iex> package = ExCorreios.Shipping.Packages.Package.build(:package_box, dimensions)
      iex> shipping_params = %{
        destination: "05724005",
        origin: "08720030",
        enterprise: "",
        password: "",
        receiving_alert: false,
        declared_value: 0,
        manually_entered: false
      }
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
  @spec calculate(list(atom), %Package{}, map(), list(Keyword.t())) ::
          {:ok, list(map)} | {:error, atom()}
  defdelegate calculate(services, package, params), to: Calculator
  defdelegate calculate(services, package, params, opts), to: Calculator

  @doc """
  Finds an address by a postal code.

  ## Examples

      iex> ExCorreios.find_address("35588-000")
      {:ok,
         %{
           city: "Arcos",
           complement: "",
           neighborhood: "",
           state: "MG",
           street: "",
           zipcode: "35588-000"
         }}

      iex> ExCorreios.find_address("00000-000")
      {:error, %{reason: "CEP INVÁLIDO"}}
  """
  @spec find_address(String.t()) :: {:ok, address()} | {:error, %{reason: String.t()}}
  def find_address(postal_code) do
    {status, result} = CEP.find_address(postal_code)
    {status, Map.from_struct(result)}
  end
end
