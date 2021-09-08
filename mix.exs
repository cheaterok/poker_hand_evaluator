defmodule PokerHandEvaluator.MixProject do
  use Mix.Project

  def project do
    [
      app: :poker_hand_evaluator,
      version: "0.1.0",
      elixir: "~> 1.12",
      elixirc_paths: elixirc_paths(Mix.env()),
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      dialyzer: dialyzer()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    []
  end

  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_), do: ["lib"]

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:dry_struct, github: "cheaterok/dry_struct", runtime: false},
      {:type_union, github: "cheaterok/type_union", runtime: false},
      {:dialyxir, "~> 1.0", only: [:dev], runtime: false},
      {:credo, "~> 1.5", only: [:dev, :test], runtime: false}
    ]
  end

  defp dialyzer do
    [
      flags: ~w(error_handling underspecs unknown unmatched_returns)a
    ]
  end
end
