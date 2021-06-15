defmodule Graphmath.Mixfile do
  use Mix.Project

  def project do
    [
      app: :graphmath,
      version: "2.5.0",
      elixir: "~> 1.12",
      elixirc_paths: elixirc_paths(Mix.env()),
      description: description(),
      package: package(),
      docs: &docs/0,
      deps: deps(),
      test_coverage: [tool: ExCoveralls]
    ]
  end

  def application, do: []

  defp description do
    """
    Graphmath is a library for doing 2D and 3D math, supporting matrix and vector operations.
    """
  end

  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(:docs), do: ["lib", "test/support"]
  defp elixirc_paths(_), do: ["lib"]

  defp deps do
    [
      {:credo, "~> 1.5.6", only: :dev},
      {:dialyxir, "~> 1.1.0", only: [:dev], runtime: false},
      {:ex_doc, "~> 0.24.2", only: [:dev, :docs]},
      {:excoveralls, "~> 0.14.1", only: [:test, :dev]},
      {:inch_ex, "~> 2.0.0", only: :docs}
    ]
  end

  defp package do
    [
      maintainers: ["Chris Ertel", "Ivan Miranda", "Matthew Philyaw"],
      licenses: ["Public Domain (unlicense)", "WTFPL", "New BSD"],
      links: %{"GitHub" => "https://github.com/crertel/graphmath"}
    ]
  end

  defp docs do
    {ref, 0} = System.cmd("git", ["rev-parse", "--verify", "--quiet", "HEAD"])
    [source_ref: ref, main: "api-reference"]
  end
end
