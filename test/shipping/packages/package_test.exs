defmodule ExCorreios.Shipping.Packages.PackageTest do
  use ExUnit.Case
  doctest ExCorreios.Shipping.Packages.Package

  import ExCorreios.Factory

  alias ExCorreios.Shipping.Packages.Package

  describe "Package.build/2" do
    test "returns a built package" do
      package_item = build(:package_item)

      assert %{diameter: 40, format: 1, height: 2.0, length: 16.0, weight: 0.3, width: 11.0} =
               Package.build(:package_box, package_item)
    end

    test "returns a built package when you pass a list of items" do
      package_items = build_list(2, :package_item)

      assert %{diameter: 80, format: 1, height: 8.9, length: 16.0, weight: 0.6, width: 11.0} =
               Package.build(:package_box, package_items)
    end
  end
end
