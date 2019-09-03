defmodule ExCorreios.Shipping.ShippingTest do
  use ExUnit.Case

  import ExCorreios.Factory

  alias ExCorreios.Shipping.{Packages.Package, Shipping}

  describe "Shipping.new/3" do
    test "returns a shipping struct" do
      package = Package.build(:package_box, build(:package_item))

      assert %Shipping{} =
               Shipping.new([:pac, :sedex], package, %{
                 destination: "06666666",
                 origin: "03333333"
               })
    end

    test "raises an error when building struct and format key was not given" do
      package = Package.build(:package_box, build(:package_item))

      error_message =
        "the following keys must also be given when building struct ExCorreios.Shipping.Shipping: [:destination, :origin]"

      assert_raise ArgumentError, error_message, fn ->
        Shipping.new([:pac], package, %{})
      end
    end
  end
end
