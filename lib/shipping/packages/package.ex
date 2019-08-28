defmodule ExCorreios.Shipping.Packages.Package do
  @moduledoc """
  This module provides a package struct.
  """

  @enforce_keys [:format]

  defstruct diameter: 0.0, format: nil, height: 0.0, length: 0.0, weight: 0.0, width: 0.0

  @type t :: %__MODULE__{
          diameter: float(),
          format: integer(),
          height: float(),
          length: float(),
          weight: float(),
          width: float()
        }

  alias ExCorreios.Shipping.Packages.Format

  @spec new(map()) :: %__MODULE__{}
  def new(params) do
    package_params = Map.update!(params, :format, &Format.get/1)

    struct!(__MODULE__, package_params)
  end
end
