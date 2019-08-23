defmodule Correios.Shipping.Package do
  @moduledoc false

  @enforce_keys [:format]

  defstruct diameter: 0, format: nil, height: 0, length: 0, weight: 0, width: 0

  @formats %{package_box: 1, roll_prism: 2, envelope: 3}

  def get_format(format), do: @formats[format]
end
