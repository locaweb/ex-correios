# ExCorreios

Elixir client that integrates with Correios API. It calculates price and deadline shipping.

## Installation

Add ExCorreios to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:ex_correios, git: "https://code.locaweb.com.br/criador-sites/ex-correios"}
  ]
end
```

## Configuration

Add the following config to your config.exs file:

```elixir
config :ex_correios,
  base_url: "http://ws.correios.com.br/calculador/CalcPrecoPrazo.aspx"
```

## Getting started

1 - Build one or more package items

```elixir
iex> dimensions = %{diameter: 40.0, height: 2.0, length: 16.0, weight: 0.9, width: 11.0}
iex> dimensions2 = %{diameter: 0.0, height: 0.0, length: 0.0, weight: 0.0, width: 0.0}
```

2 - Build a package with an item to calculate shipping

```elixir
iex> package = ExCorreios.Shipping.Packages.Package.build(:package_box, [dimensions])
%ExCorreios.Shipping.Packages.Package{
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
iex> package = ExCorreios.Shipping.Packages.Package.build(:package_box, [dimensions2])
%ExCorreios.Shipping.Packages.Package{
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
iex> ExCorreios.Shipping.Packages.Package.build(:package_box, [%{weight: 0.3}])
%ExCorreios.Shipping.Packages.Package{
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
iex> package = ExCorreios.Shipping.Packages.Package.build(:package_box, [dimensions, dimensions2])
%ExCorreios.Shipping.Packages.Package{
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
...>  destination: "05724005",
...>  origin: "08720030",
...>  enterprise: "",
...>  password: "",
...>  receiving_alert: false,
...>  declared_value: 0,
...>  manually_entered: false
...> }
iex> ExCorreios.calculate([:pac], package, shipping_params)
{:ok,
  [
    %{
      deadline: 5,
      declared_value: 0.0,
      error_code: "0",
      error_message: "",
      home_delivery: "S",
      manually_entered_value: 0.0,
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
      error_code: "0",
      error_message: "",
      home_delivery: "S",
      manually_entered_value: 0.0,
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
      error_code: "0",
      error_message: "",
      home_delivery: "S",
      manually_entered_value: 0.0,
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
     error_code: "0",
     error_message: "",
     home_delivery: "S",
     manually_entered_value: 0.0,
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
     error_code: "008",
     error_message: "Serviço indisponível para o trecho informado.",
     home_delivery: "",
     manually_entered_value: 0.0,
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
{:error, :timeout}
```

3.3 - Options

Available options and their default values:

```elixir
[
  base_url: "http://ws.correios.com.br/calculador/CalcPrecoPrazo.aspx", # defined in the project config.
  recv_timeout: 20_000, # timeout for establishing a TCP or SSL connection, in milliseconds.
  timeout: 20_000 # timeout for receiving an HTTP response from the socket.
]
```

## Running tests

```
$ git clone https://code.locaweb.com.br/criador-sites/ex-correios.git
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
