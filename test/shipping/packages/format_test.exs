defmodule ExCorreios.Shipping.Packages.FormatTest do
  use ExUnit.Case

  alias ExCorreios.Shipping.Packages.Format

  describe "Format.get_format/1" do
    test "returns a package format number" do
      assert Format.get(:package_box) == 1
      assert Format.get(:roll_prism) == 2
      assert Format.get(:envelope) == 3
    end

    test "returns nil when the package format doesn't exists" do
      refute Format.get(:pacoto)
    end
  end
end
