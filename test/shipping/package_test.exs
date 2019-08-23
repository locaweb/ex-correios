defmodule ExCorreios.Shipping.PackageTest do
  use ExUnit.Case

  alias ExCorreios.Shipping.Package

  describe "Package.get_format/1" do
    test "returns a package format number" do
      assert Package.get_format(:package_box) == 1
      assert Package.get_format(:roll_prism) == 2
      assert Package.get_format(:envelope) == 3
    end

    test "returns nil when the package doesn't exists" do
      refute Package.get_format(:pacoto)
    end

    test "returns a package struct" do
      assert %Package{diameter: 16, format: 1, height: 12.9, length: 2.0, weight: 0.8, width: 11.2}
    end

    test "raises an error when building struct and format key was not given" do
      error_message = "the following keys must also be given when building struct ExCorreios.Shipping.Package: [:format]"
      content = quote(do: %Package{diameter: 16, height: 12.9, length: 2.0, weight: 0.8, width: 11.2})

      assert_raise ArgumentError, error_message, fn -> Code.eval_quoted(content) end
    end
  end
end
