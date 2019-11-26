defmodule ExCorreios do
  @moduledoc """
  This module provides a function to calculate shipping based on one or more services.
  """

  @timeout_default 10_000

  alias ExCorreios.Request.{Client, Url}
  alias ExCorreios.Shipping.Packages.Package
  alias ExCorreios.Shipping.Shipping

  @typep address :: %{city: String.t(), complement: String.t(), neighborhood: String.t(), state: String.t(), street: String.t(), zipcode: String.t()}

  @doc """
  Calculate shipping based on one or more services.

  ## Examples

      iex> dimensions = [%{diameter: 40, width: 11.0, height: 2.0, length: 16.0, weight: 0.9}]
      iex> package = ExCorreios.Shipping.Packages.Package.build(:package_box, dimensions)
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
  @spec calculate(list(atom), %Package{}, map(), list(Keyword.t())) ::
          {:ok, list(map)} | {:error, atom()}
  def calculate(services, package, params, opts \\ [])
  def calculate([], _package, _params, _opts), do: {:error, :empty_service_list}

  def calculate(services, package, params, opts) do
    results =
      services
      |> Task.async_stream(&calculate_service(&1, package, params, opts), timeout: @timeout_default)
      |> Enum.map(fn {:ok, result} -> result end)

    results
    |> Enum.all?(&match?({:ok, _}, &1))
    |> Kernel.&&({:ok, format_results(results)})
    |> Kernel.||({:error, "Error to fetching a service."})
  end

  @spec find_address(String.t()) :: {:ok, address()} | {:error, %{reason: String.t()}}
  def find_address(postal_code) do
    {status, address} = Correios.CEP.find_address(postal_code)
    {status, Map.from_struct(address)}
  end

  defp format_results(results),
    do: Enum.map(results, fn {:ok, result} -> result end)

  defp calculate_service(service, package, params, opts) do
    base_url = Keyword.get(opts, :base_url)
    request_options = request_options(opts)

    {status, result} =
      service
      |> Shipping.new(package, params)
      |> Url.build(base_url)
      |> Client.get(request_options)

    {status, Map.put(result, :service, service)}
  end

  defp request_options(opts) do
    recv_timeout = Keyword.get(opts, :recv_timeout, @timeout_default)
    timeout = Keyword.get(opts, :timeout, @timeout_default)

    [recv_timeout: recv_timeout, timeout: timeout]
  end
end
