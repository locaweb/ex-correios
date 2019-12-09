defmodule ExCorreios.Address do
  @moduledoc "This module provides functions to get an address."

  alias ExCorreios.Address.Request.{Body, Response}
  alias ExCorreios.Request.Client

  @enforce_keys [:city, :complement, :district, :postal_code, :state, :street]
  defstruct @enforce_keys

  @type t :: %__MODULE__{
          city: String.t(),
          complement: String.t(),
          district: String.t(),
          postal_code: String.t(),
          state: String.t(),
          street: String.t()
        }

  @spec find(String.t(), keyword()) :: {:ok, __MODULE__.t()} | {:error, atom()}
  def find(postal_code, opts \\ []) do
    opts
    |> address_url()
    |> Client.post(Body.build(postal_code), opts)
    |> Response.process()
    |> build_address()
  rescue
    _error in Protocol.UndefinedError -> {:error, :unexpected_error}
  end

  defp build_address({:ok, attrs}), do: {:ok, struct(__MODULE__, attrs)}
  defp build_address(response), do: response

  defp address_url(opts),
    do: opts[:address_url] || Application.get_env(:ex_correios, :address_url)
end
