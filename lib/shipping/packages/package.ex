defmodule ExCorreios.Shipping.Packages.Package do
  @moduledoc false

  @enforce_keys [:format]

  defstruct [:diameter, :format, :height, :length, :weight, :width]

  @type t :: %__MODULE__{
          diameter: float(),
          format: Integer.t(),
          height: float(),
          length: float(),
          weight: float(),
          width: float()
        }

  @default_values %{
    diameter: 0.0,
    height: 0.0,
    length: 0.0,
    weight: 0.0,
    width: 0.0
  }

  alias ExCorreios.Shipping.Packages.Format

  @spec new(map()) :: %__MODULE__{}
  def new(params) do
    package_params =
      @default_values
      |> Map.merge(params)
      |> Map.update!(:format, &Format.get/1)

    struct!(__MODULE__, package_params)
  end
end
