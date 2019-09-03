defmodule ExCorreios.Shipping.Packages.Package do
  @moduledoc """
  This module provides a package struct
  """

  defstruct diameter: 0.0, format: nil, height: 0.0, length: 0.0, weight: 0.0, width: 0.0

  @iata_coefficient 6000
  @min_dimensions %{height: 2.0, length: 16.0, width: 11.0}

  alias ExCorreios.Shipping.Packages.{Format, PackageItem}

  @doc """
  Build a package with one or more items to calculate shipping

  ## Examples
    iex> package_item = ExCorreios.Shipping.Packages.PackageItem.new(%{
    ...>  diameter: 40,
    ...>  height: 2.0,
    ...>  length: 16.0,
    ...>  weight: 0.9,
    ...>  width: 11.0
    ...> })
    iex> ExCorreios.Shipping.Packages.Package.build(:package_box, [package_item, package_item])
    %ExCorreios.Shipping.Packages.Package{
        diameter: 80,
        format: 1,
        height: 8.9,
        length: 16.0,
        weight: 1.8,
        width: 11.0
    }
  """
  @spec build(atom(), list(map)) :: map()
  def build(format, items) when is_list(items) do
    dimension = calculate_dimensions(items)

    package = %{
      weight: sum(:weight, items),
      diameter: sum(:diameter, items),
      height: dimension,
      length: dimension,
      width: dimension
    }

    build_package(format, package)
  end

  @doc """
  Build a package with an item to calculate shipping

  ## Examples
    iex> package_item = ExCorreios.Shipping.Packages.PackageItem.new(%{
    ...>  diameter: 40,
    ...>  height: 2.0,
    ...>  length: 16.0,
    ...>  weight: 0.9,
    ...>  width: 11.0
    ...> })
    iex> ExCorreios.Shipping.Packages.Package.build(:package_box, package_item)
    %ExCorreios.Shipping.Packages.Package{
        diameter: 40,
        format: 1,
        height: 2.0,
        length: 16.0,
        weight: 0.9,
        width: 11.0
    }
  """
  @spec build(atom(), map()) :: map()
  def build(format, item) do
    map = Map.delete(item, :__struct__)

    build_package(format, map)
  end

  defp build_package(format, package) do
    package =
      package
      |> Map.merge(dimensions(package))
      |> Map.put(:format, Format.get(format))

    struct(__MODULE__, package)
  end

  defp calculate_dimensions(items) do
    items
    |> Enum.reduce(0, fn item, acc -> PackageItem.volume(item) + acc end)
    |> Kernel./(@iata_coefficient)
    |> Float.round(2)
  end

  defp sum(key, items), do: Enum.reduce(items, 0, fn item, acc -> Map.get(item, key) + acc end)

  defp dimensions(dimensions) do
    %{
      height: higher_value(dimensions.height, @min_dimensions.height),
      length: higher_value(dimensions.length, @min_dimensions.length),
      width: higher_value(dimensions.width, @min_dimensions.width)
    }
  end

  defp higher_value(value, min_value) when value > min_value, do: value
  defp higher_value(_value, min_value), do: min_value
end
