# ExCorreios

Elixir client that integrates with Correios API.

## Features:

- Calculate shipping price and deadline;
- Search an address by postal code.

## Installation

Add ExCorreios to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:ex_correios, "~> 1.1.4"}
  ]
end
```

## Configuration

Add the following config to your config.exs file:

```elixir
config :ex_correios,
  address_url: "https://apps.correios.com.br/SigepMasterJPA/AtendeClienteService/AtendeCliente",
  calculator_url: "http://ws.correios.com.br/calculador/CalcPrecoPrazo.aspx",
  proxy: {"proxyhost.com", "8866"}
```

## Getting started

### Calculate

1 - Build one or more package items

```elixir
iex> dimensions = %{diameter: 40.0, height: 2.0, length: 16.0, weight: 0.9, width: 11.0}
iex> dimensions2 = %{diameter: 0.0, height: 0.0, length: 0.0, weight: 0.0, width: 0.0}
```

2 - Build a package with an item to calculate shipping

```elixir
iex> package = ExCorreios.Calculator.Shipping.Package.build(:package_box, [dimensions])
%ExCorreios.Calculator.Shipping.Package{
  diameter: 40.0,
  format: 1,
  height: 2.0,
  length: 16.0,
  weight: 0.9,
  width: 11.0
}
```

2.1 - When the package dimensions is smaller than the min dimensions accepted, we'll use the min dimensions defined by the correios

```elixir
iex> package = ExCorreios.Calculator.Shipping.Package.build(:package_box, [dimensions2])
%ExCorreios.Calculator.Shipping.Package{
  diameter: 0.0,
  format: 1,
  height: 2.0,
  length: 16.0,
  weight: 0.0,
  width: 11.0
}
```

2.2 - It's possible to pass only the weight to build a package

```elixir
iex> ExCorreios.Calculator.Shipping.Package.build(:package_box, [%{weight: 0.3}])
%ExCorreios.Calculator.Shipping.Package{
  diameter: 0.0,
  format: 1,
  height: 2.0,
  length: 16.0,
  weight: 0.3,
  width: 11.0
}
```

2.3 - Build a package with one or more items to calculate shipping

```elixir
iex> package = ExCorreios.Calculator.Shipping.Package.build(:package_box, [dimensions, dimensions2])
%ExCorreios.Calculator.Shipping.Package{
  diameter: 40.0,
  format: 1,
  height: 7.06,
  length: 16.0,
  weight: 0.9,
  width: 11.0
}
```

3 - Calculate shipping based on one or more services

```elixir
iex> shipping_params = %{
  destination: "05724005",
  origin: "08720030",
  enterprise: "",
  password: "",
  receiving_alert: false,
  declared_value: 0,
  manually_entered: false
}
iex> ExCorreios.calculate([:pac], package, shipping_params)
{:ok,
  [
    %{
      deadline: 5,
      declared_value: 0.0,
      error: nil,
      error_code: "0",
      error_message: "",
      home_delivery: "S",
      manually_entered_value: 0.0,
      name: "PAC",
      notes: "",
      receiving_alert_value: 0.0,
      response_status: "0",
      saturday_delivery: "N",
      service_code: "04510",
      value: 19.8,
      value_without_additionals: 19.8
    }
  ]
}
iex> ExCorreios.calculate([:pac, :sedex], package, shipping_params)
{:ok,
  [
    %{
      deadline: 5,
      declared_value: 0.0,
      error: nil,
      error_code: "0",
      error_message: "",
      home_delivery: "S",
      manually_entered_value: 0.0,
      name: "PAC",
      notes: "",
      receiving_alert_value: 0.0,
      response_status: "0",
      saturday_delivery: "N",
      service_code: "04510",
      value: 19.8,
      value_without_additionals: 19.8
    },
    %{
      deadline: 2,
      declared_value: 0.0,
      error: nil,
      error_code: "0",
      error_message: "",
      home_delivery: "S",
      manually_entered_value: 0.0,
      name: "SEDEX",
      notes: "",
      receiving_alert_value: 0.0,
      response_status: "0",
      saturday_delivery: "S",
      service_code: "04014",
      value: 21.2,
      value_without_additionals: 21.2
    }
  ]
}
```

3.1 - It's possible for a service returns an error message while the other returns a success message

```elixir
iex> ExCorreios.calculate([:pac, :sedex_hoje], package, shipping_params)
{:ok,
 [
   %{
     deadline: 5,
     declared_value: 0.0,
     error: nil,
     error_code: "0",
     error_message: "",
     home_delivery: "S",
     manually_entered_value: 0.0,
     name: "PAC",
     notes: "",
     receiving_alert_value: 0.0,
     response_status: "0",
     saturday_delivery: "N",
     service_code: "04510",
     value: 19.8,
     value_without_additionals: 19.8
   },
   %{
     deadline: 0,
     declared_value: 0.0,
     error: :invalid_destination_postal_code,
     error_code: "008",
     error_message: "Serviço indisponível para o trecho informado.",
     home_delivery: "",
     manually_entered_value: 0.0,
     name: "SEDEX HOJE",
     notes: "",
     receiving_alert_value: 0.0,
     response_status: "008",
     saturday_delivery: "",
     service_code: "40290",
     value: 0.0,
     value_without_additionals: 0.0
   }
 ]}
```

3.2 - Returns an error

```elixir
iex> ExCorreios.calculate([:pac, :sedex_hoje], package, shipping_params)
{:error, "Error fetching services."}
```

3.3 - Options

Available options:

```elixir
[
  calculator_url: "http://ws.correios.com.br/calculador/CalcPrecoPrazo.aspx", # defined in the project config.
  recv_timeout: 10_000, # timeout for establishing a TCP or SSL connection, in milliseconds.
  timeout: 10_000 # timeout for receiving an HTTP response from the socket.
]
```

### Find address

1 - Find an address by a valid postal code

```elixir
iex> ExCorreios.find_address("35588-000")
{:ok,
  %{
  city: "Arcos",
  complement: "",
  district: "",
  postal_code: "35588000",
  state: "MG",
  street: ""
  }}
```

1.1 - Returns an error when postal code is invalid

iex> ExCorreios.find_address("00000-000")
{:error, :invalid_postal_code}

1.2 - Available options:

```elixir
[
  address_url: "https://apps.correios.com.br/SigepMasterJPA/AtendeClienteService/AtendeCliente", # defined in the project config.
  recv_timeout: 10_000, # timeout for establishing a TCP or SSL connection, in milliseconds.
  timeout: 10_000 # timeout for receiving an HTTP response from the socket.
]
```

## Running tests

```
$ git clone https://github.com/locaweb/ex-correios.git
$ cd ex-correios
$ mix deps.get
$ mix test --trace
```

## Running tests coverage check

```
$ mix test --cover
```

## Running code formatter

```
$ mix format
```

## Credo

Credo is a static code analysis tool for the Elixir language, to run credo:

```
$ mix credo --strict
```

## Contributing

Check out [Contributing](CONTRIBUTING.md) guide.

## License

MIT license

Copyright (c) 2020 Locaweb

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
