defmodule ExCorreios.Shipping.Packages.PackageItemTest do
  use ExUnit.Case

  alias ExCorreios.Shipping.Packages.PackageItem

  describe "PackageItem.new/1" do
    test "returns a package item struct" do
      assert %PackageItem{} = PackageItem.new(%{})
    end
  end

  describe "PackageItem.volume/1" do
    test "returns the item volume" do
      package_item = PackageItem.new(%{width: 11.0, height: 2.0, length: 16.0})

      assert PackageItem.volume(package_item) == 352.0
    end
  end
end
