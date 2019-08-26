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
          width: float(),
        }
end
