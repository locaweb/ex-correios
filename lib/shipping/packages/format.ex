defmodule ExCorreios.Shipping.Packages.Format do
  @formats %{package_box: 1, roll_prism: 2, envelope: 3}

  @spec get(atom()) :: integer()
  def get(format), do: @formats[format]
end
