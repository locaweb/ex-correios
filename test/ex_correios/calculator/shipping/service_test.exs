defmodule ExCorreios.Calculator.Shipping.ServiceTest do
  use ExUnit.Case, async: true

  alias ExCorreios.Calculator.Shipping.Service

  describe "Service.get_service/1" do
    test "returns a service" do
      expected_service = %{code: "04014", name: "SEDEX", description: "SEDEX sem contrato"}

      assert Service.get_service(:sedex) == expected_service
    end

    test "returns nil when a service with given key does not exist" do
      refute Service.get_service(:sedexerxes)
    end
  end
end
