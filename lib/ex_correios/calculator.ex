defmodule ExCorreios.Calculator do
  @moduledoc """
  This module calculates a shipping based on `Correios` services and package dimensions.
  """

  alias ExCorreios.Calculator.Request.{Response, Url}
  alias ExCorreios.Calculator.{Shipping, Shipping.Package}
  alias ExCorreios.Request.Client

  @calculate_task_timeout 60_000

  @doc "Calculates a shipping."
  @spec calculate(list(atom), %Package{}, map(), keyword()) ::
          {:ok, list(map())} | {:error, atom()}
  def calculate(services, package, params, opts \\ [])
  def calculate([], _package, _params, _opts), do: {:error, :empty_service_list}

  def calculate(services, package, params, opts) do
    results =
      services
      |> Task.async_stream(&calculate_service(&1, package, params, opts),
        timeout: @calculate_task_timeout
      )
      |> Enum.map(&elem(&1, 1))

    results
    |> Enum.all?(&match?({:ok, _}, &1))
    |> Kernel.&&({:ok, format_results(results)})
    |> Kernel.||({:error, "Error fetching services."})
  end

  defp format_results(results), do: Enum.map(results, fn {:ok, result} -> result end)

  defp calculate_service(service, package, params, opts) do
    request =
      service
      |> Shipping.new(package, params)
      |> Url.build(opts[:calculator_url])
      |> Client.get(opts)
      |> Response.process()

    with {:ok, result} when is_map(result) <- request do
      {:ok, Map.put(result, :name, format_service_name(service))}
    end
  end

  defp format_service_name(name),
    do: name |> to_string() |> String.upcase() |> String.replace("_", " ")
end
