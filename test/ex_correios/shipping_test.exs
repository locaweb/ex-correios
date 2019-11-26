defmodule ExCorreios.ShippingTest do
  use ExUnit.Case, async: true

  import ExCorreios.Factory

  alias ExCorreios.Shipping

  describe "Shipping.new/3" do
    test "returns a shipping struct" do
      package = build(:package)

      assert %Shipping{} =
               Shipping.new([:pac, :sedex], package, %{
                 destination: "06666666",
                 origin: "03333333"
               })
    end
  end
end
