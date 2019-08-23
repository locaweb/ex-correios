defmodule ExCorreios.MixProject do
  use Mix.Project

  def project do
    [
      app: :ex_correios,
      version: "0.1.0",
      elixir: "~> 1.8",
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
      {:httpotion, "~> 3.1.0"},
      {:sweet_xml, "~> 0.6.5"}
    ]
  end
end
