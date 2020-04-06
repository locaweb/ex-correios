defmodule ExCorreios.MixProject do
  use Mix.Project

  def project do
    [
      app: :ex_correios,
      version: "1.1.3",
      elixir: "~> 1.10",
      elixirc_paths: elixirc_paths(Mix.env()),
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  def application do
    [
      extra_applications: [:logger]
    ]
  end

  defp deps do
    [
      {:bypass, "~> 1.0", only: :test},
      {:credo, "~> 1.1", only: [:dev, :test], runtime: false},
      {:ex_machina, "~> 2.3", only: :test},
      {:httpoison, "~> 1.5"},
      {:sweet_xml, "~> 0.6"}
    ]
  end

  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_), do: ["lib"]
end
