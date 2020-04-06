defmodule ExCorreios.MixProject do
  use Mix.Project

  @version "1.1.3"
  @repo_url "https://github.com/locaweb/ex-correios"

  def project do
    [
      app: :ex_correios,
      deps: deps(),
      elixir: "~> 1.10",
      elixirc_paths: elixirc_paths(Mix.env()),
      start_permanent: Mix.env() == :prod,
      version: @version,

      # Hex
      description: "Elixir client that integrates with Brazilian Correios API.",
      package: package(),

      # Docs
      name: "ExCorreios",
      docs: docs()
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

  defp package do
    [
      maintainers: ["Locaweb"],
      licenses: ["MIT"],
      links: %{"GitHub" => @repo_url}
    ]
  end

  defp docs do
    [
      main: "ExCorreios",
      source_ref: "v#{@version}",
      source_url: @repo_url
    ]
  end

  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_), do: ["lib"]
end
