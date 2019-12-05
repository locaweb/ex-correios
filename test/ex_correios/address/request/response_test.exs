defmodule ExCorreios.Address.Request.ResponseTest do
  use ExUnit.Case, async: true

  alias ExCorreios.Address.Request.Response

  @fixtures_path "test/support/fixtures/correios/address"

  describe "Response.process/1" do
    test "returns a map with address attributes" do
      body = File.read!("#{@fixtures_path}/success_response.xml")
      response = %HTTPoison.Response{status_code: 200, body: body}

      assert Response.process({:ok, response}) ==
               {:ok,
                %{
                  city: "Lavras",
                  complement: "",
                  neighborhood: "Centro",
                  postal_code: "37200001",
                  state: "MG",
                  street: "Rua Gustavo Pena"
                }}
    end

    test "returns `invalid_postal_code` error when postal code is invalid" do
      body = File.read!("#{@fixtures_path}/invalid_response.xml")
      response = %HTTPoison.Response{status_code: 500, body: body}

      assert Response.process({:ok, response}) == {:error, :invalid_postal_code}
    end

    test "returns `postal_code_not_found` error when postal code not found" do
      body = File.read!("#{@fixtures_path}/not_found_response.xml")
      response = %HTTPoison.Response{status_code: 500, body: body}

      assert Response.process({:ok, response}) == {:error, :postal_code_not_found}
    end

    test "returns `unexpected_error` error when the reason for the error is not known" do
      body = File.read!("#{@fixtures_path}/unexpected_response.xml")
      response = %HTTPoison.Response{status_code: 500, body: body}

      assert Response.process({:ok, response}) == {:error, :unexpected_error}
    end
  end
end
