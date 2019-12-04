defmodule ExCorreios.Calculator.Shipping.Package do
  @moduledoc """
  This module provides a package struct
  """

  @enforce_keys [:format, :weight]

  defstruct diameter: 0.0, format: nil, height: 0.0, length: 0.0, weight: 0.0, width: 0.0

  @type t :: %__MODULE__{
          diameter: float(),
          format: integer(),
          height: float(),
          length: float(),
          weight: float(),
          width: float()
        }

  @iata_coefficient 6000
  @formats %{package_box: 1, roll_prism: 2, envelope: 3}
  @min_dimensions %{height: 2.0, length: 16.0, width: 11.0}

  @doc """
  Build a package with one or more items to calculate shipping

  ## Examples
    iex> dimensions = [%{diameter: 40, height: 2.0, length: 16.0, weight: 0.9, width: 11.0}]
    iex> ExCorreios.Shipping.Packages.Package.build(:package_box, dimensions)
    %ExCorreios.Shipping.Packages.Package{
      diameter: 40,
      format: 1,
      height: 2.0,
      length: 16.0,
      weight: 0.9,
      width: 11.0
    }

    # it's possible to pass only the weight to build a package
    iex> ExCorreios.Shipping.Packages.Package.build(:package_box, [%{weight: 0.3}])
    %ExCorreios.Shipping.Packages.Package{
      diameter: 0.0,
      format: 1,
      height: 2.0,
      length: 16.0,
      weight: 0.3,
      width: 11.0
    }
  """
  @spec build(atom(), list(map)) :: map()
  def build(format, [item]), do: build_package(format, item)

  def build(format, items) do
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

  defp build_package(format, package) do
    package =
      package
      |> Map.merge(dimensions(package))
      |> Map.put(:format, get_format(format))

    struct(__MODULE__, package)
  end

  def get_format(format), do: @formats[format]

  defp calculate_dimensions(items) do
    items
    |> Enum.reduce(0, fn item, acc -> volume(item) + acc end)
    |> Kernel./(@iata_coefficient)
    |> Float.round(2)
  end

  defp volume(%{height: height, length: length, width: width} = _item),
    do: height * length * width

  defp volume(_item), do: 0

  defp sum(key, items), do: Enum.reduce(items, 0, fn item, acc -> Map.get(item, key, 0) + acc end)

  defp dimensions(dimensions) do
    height = Map.get(dimensions, :height, 0)
    length = Map.get(dimensions, :length, 0)
    width = Map.get(dimensions, :width, 0)

    %{
      height: higher_value(height, @min_dimensions.height),
      length: higher_value(length, @min_dimensions.length),
      width: higher_value(width, @min_dimensions.width)
    }
  end

  defp higher_value(value, min_value) when value > min_value, do: value
  defp higher_value(_value, min_value), do: min_value
end
