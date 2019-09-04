defmodule ExCorreios.Shipping.Packages.PackageTest do
  use ExUnit.Case

  alias ExCorreios.Shipping.Packages.Package

  describe "Package.build/2" do
    test "returns a built package" do
      dimensions = %{diameter: 40, height: 2.0, length: 16.0, weight: 0.3, width: 11.0}

      assert %{diameter: 40, format: 1, height: 2.0, length: 16.0, weight: 0.3, width: 11.0} =
               Package.build(:package_box, dimensions)
    end

    test "returns a built package when you pass a list of items" do
      dimensions = %{diameter: 40, height: 2.0, length: 16.0, weight: 0.3, width: 11.0}

      assert %{diameter: 80, format: 1, height: 2.0, length: 16.0, weight: 0.6, width: 11.0} =
               Package.build(:package_box, [dimensions, dimensions])
    end
  end
end
