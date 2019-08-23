defmodule Correios.Shipping.Shipping do
  @enforce_keys [:destination, :package, :origin, :services]

  defstruct [
    :declared_value,
    :destination,
    :enterprise,
    :manually_entered,
    :origin,
    :package,
    :password,
    :receiving_alert,
    :services
  ]

  @type t :: %__MODULE__{
          declared_value: String.t(),
          destination: String.t(),
          enterprise: String.t(),
          manually_entered: String.t(),
          origin: String.t(),
          package: struct(),
          password: String.t(),
          receiving_alert: String.t(),
          services: List.t()
        }
end
