defmodule ExCorreios.Shipping.ShippingTest do
  use ExUnit.Case

  alias ExCorreios.Shipping.Shipping

  describe "Shipping.new/2" do
    test "returns a shipping struct" do
      assert %Shipping{} =
               Shipping.new(:pac, %{
                 format: :package_box,
                 destination: "06666666",
                 origin: "03333333"
               })
    end

    test "returns a shipping struct with a service list" do
      assert %Shipping{} =
               Shipping.new([:pac, :sedex], %{
                 format: :package_box,
                 destination: "06666666",
                 origin: "03333333"
               })
    end

    test "raises an error when building struct and format key was not given" do
      error_message =
        "the following keys must also be given when building struct ExCorreios.Shipping.Shipping: [:destination, :origin]"

      assert_raise ArgumentError, error_message, fn ->
        Shipping.new(:pac, %{format: :package_box})
      end
    end
  end
end
