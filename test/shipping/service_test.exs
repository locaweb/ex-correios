defmodule ExCorreios.Shipping.ServiceTest do
  use ExUnit.Case

  alias ExCorreios.Shipping.Service

  describe "Service.get_service/1" do
    test "returns a service avaiable" do
      expected_service = %{code: "04510", name: "PAC", description: "PAC sem contrato"}

      assert Service.get_service(:pac) == expected_service
    end

    test "returns nil when the service doesn't exists" do
      refute Service.get_service(:two_pac)
    end
  end

  describe "Service.get_services/1" do
    test "returns service list" do
      expected_services = [
        pac: %{code: "04510", name: "PAC", description: "PAC sem contrato"},
        sedex: %{code: "04014", name: "SEDEX", description: "SEDEX sem contrato"}
      ]

      assert Service.get_services([:pac, :sedex]) == expected_services
    end

    test "returns a empty when the services don't exist" do
      assert Service.get_services([:two_pac, :sedequis]) == []
    end

    test "returns only avaiable services" do
      pac_service = %{code: "04510", name: "PAC", description: "PAC sem contrato"}

      assert Service.get_services([:pac, :sedexerxes]) == [pac: pac_service]
    end
  end
end
