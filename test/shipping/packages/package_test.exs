defmodule ExCorreios.Shipping.Packages.PackageTest do
  use ExUnit.Case

  alias ExCorreios.Shipping.Packages.Package

  describe "Package.new/1" do
    test "returns a package struct" do
      assert %Package{} = Package.new(%{format: 1})
    end

    test "raises an error when building struct and format key was not given" do
      error_message =
        "key :format not found in: %{diameter: 0.0, height: 0.0, length: 0.0, weight: 0.0, width: 0.0}"

      assert_raise KeyError, error_message, fn -> Package.new(%{}) end
    end
  end
end
