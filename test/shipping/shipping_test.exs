defmodule ExCorreios.Shipping.ShippingTest do
  use ExUnit.Case

  alias ExCorreios.Shipping.Shipping

  describe "Shipping.get_format/1" do
    test "returns a shipping struct" do
      assert %Shipping{destination: "08720002", origin: "08720003", services: ["09123"], package: %{}}
    end

    test "raises an error when building struct and format key was not given" do
      error_message = "the following keys must also be given when building struct ExCorreios.Shipping.Shipping: [:destination, :package, :origin, :services]"
      content = quote(do: %Shipping{})

      assert_raise ArgumentError, error_message, fn -> Code.eval_quoted(content) end
    end
  end
end
