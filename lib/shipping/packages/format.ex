defmodule ExCorreios.Shipping.Packages.Format do
  @moduledoc false

  @formats %{package_box: 1, roll_prism: 2, envelope: 3}

  @spec get(atom()) :: Integer.t()
  def get(format), do: @formats[format]
end
