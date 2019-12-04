defmodule ExCorreios.CEP.ClientStub do
  @moduledoc false

  @fixture_path "test/support/fixtures"

  def request("35588-000", _options) do
    {:ok, File.read!("#{@fixture_path}/correios_cep_response.xml")}
  end

  def request("00000-000", _options) do
    {:error, File.read!("#{@fixture_path}/correios_cep_error_response.xml")}
  end
end
