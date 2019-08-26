defmodule ExCorreios.Shipping.Packages.PackageTest do
  use ExUnit.Case

  alias ExCorreios.Shipping.Packages.Package

  test "returns a package struct" do
    assert %Package{diameter: 16, format: 1, height: 12.9, length: 2.0, weight: 0.8, width: 11.2}
  end

  test "raises an error when building struct and format key was not given" do
    error_message = "the following keys must also be given when building struct ExCorreios.Shipping.Packages.Package: [:format]"
    content = quote(do: %Package{diameter: 16, height: 12.9, length: 2.0, weight: 0.8, width: 11.2})

    assert_raise ArgumentError, error_message, fn -> Code.eval_quoted(content) end
  end
end
