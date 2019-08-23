defmodule ExCorreios.Shipping.Package do
  @moduledoc false

  @enforce_keys [:format]

  defstruct [:diameter, :format, :height, :length, :weight, :width]

  @formats %{package_box: 1, roll_prism: 2, envelope: 3}

  def get_format(format), do: @formats[format]
end
