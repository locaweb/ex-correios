defmodule ExCorreios.Shipping.PackageTest do
  use ExUnit.Case, async: true

  alias ExCorreios.Shipping.Package

  describe "Package.build/2" do
    test "returns a built package" do
      dimensions = %{diameter: 40, height: 4.0, length: 19.0, weight: 0.9, width: 21.0}
      dimensions2 = %{diameter: 40, height: 2.0, length: 16.0, weight: 0.3, width: 11.0}

      assert %{diameter: 40, format: 1, height: 4.0, length: 19.0, weight: 0.9, width: 21.0} =
               Package.build(:package_box, [dimensions])

      assert %{diameter: 80, format: 1, height: 2.0, length: 16.0, weight: 1.2, width: 11.0} =
               Package.build(:package_box, [dimensions, dimensions2])
    end

    test "returns min dimensions when dimensions are empty" do
      assert %{diameter: 0.0, format: 1, height: 2.0, length: 16.0, weight: 0.3, width: 11.0} =
               Package.build(:package_box, [%{weight: 0.3}])
    end
  end
end
