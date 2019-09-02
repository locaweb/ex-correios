defmodule ExCorreios.Shipping.Packages.PackageItem do
  @moduledoc """
  This module provides a package item struct.
  """

  defstruct diameter: 0.0, height: 0.0, length: 0.0, weight: 0.0, width: 0.0

  @type t :: %__MODULE__{
          diameter: float(),
          height: float(),
          length: float(),
          weight: float(),
          width: float()
        }

  @doc """
  Returns a PackageItem struct

  ## Examples
    iex> ExCorreios.Shipping.Packages.PackageItem.new(%{
    ...>  diameter: 40,
    ...>  height: 2.0,
    ...>  length: 16.0,
    ...>  weight: 0.9,
    ...>  width: 11.0
    ...> })
    %{
        __struct__: ExCorreios.Shipping.Packages.PackageItem,
        diameter: 40,
        height: 2.0,
        length: 16.0,
        weight: 0.9,
        width: 11.0
    }
  """
  @spec new(map()) :: %__MODULE__{}
  def new(params), do: struct(__MODULE__, params)

  @spec volume(map()) :: float()
  def volume(%{height: height, length: length, width: width} = _item), do: height * length * width
end
