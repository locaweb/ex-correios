defmodule ExCorreios.Shipping.ServiceTest do
  use ExUnit.Case

  alias ExCorreios.Shipping.Service

  describe "Service.get_services/1" do
    test "returns service list" do
      expected_services = %{
        pac: %{code: "04510", name: "PAC", description: "PAC sem contrato"},
        sedex: %{code: "04014", name: "SEDEX", description: "SEDEX sem contrato"}
      }

      assert Service.get_services([:pac, :sedex]) == expected_services
    end

    test "returns an empty when the services don't exist" do
      assert Service.get_services([:two_pac, :sedequis]) == %{}
    end

    test "returns only available services" do
      pac_service = %{code: "04510", name: "PAC", description: "PAC sem contrato"}

      assert Service.get_services([:pac, :sedexerxes]) == %{pac: pac_service}
    end
  end
end
