defmodule Graphmath.Mixfile do
  use Mix.Project

  def project do
    [
      app: :graphmath,
      version: "3.0.0",
      elixir: "~> 1.15",
      elixirc_paths: elixirc_paths(Mix.env()),
      description: description(),
      package: package(),
      source_url: "https://github.com/crertel/graphmath",
      docs: &docs/0,
      deps: deps(),
      test_coverage: [tool: ExCoveralls],
      preferred_cli_env: [
        coveralls: :test,
        "coveralls.detail": :test,
        "coveralls.github": :test,
        "coveralls.post": :test,
        "coveralls.html": :test
      ]
    ]
  end

  def application, do: []

  defp description do
    """
    Graphmath is a library for doing 2D and 3D math, supporting matrix, vector, and quaternion operations.
    """
  end

  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(:docs), do: ["lib", "test/support"]
  defp elixirc_paths(_), do: ["lib"]

  defp deps do
    [
      {:benchee, "~> 1.3", only: :dev},
      {:benchee_html, "~> 1.0", only: :dev},
      {:benchee_markdown, "~> 0.3", only: :dev},
      {:credo, "~> 1.7.7", only: :dev},
      {:dialyxir, "~> 1.4.3", only: [:dev], runtime: false},
      {:ex_doc, "~> 0.34.2", only: [:dev, :docs]},
      {:excoveralls, "~> 0.18.2", only: [:test, :dev]}
    ]
  end

  defp package do
    [
      maintainers: ["Chris Ertel", "Ivan Miranda", "Matthew Philyaw"],
      licenses: ["Unlicense", "WTFPL", "BSD-3-Clause"],
      links: %{"GitHub" => "https://github.com/crertel/graphmath"}
    ]
  end

  defp docs do
    {ref, 0} = System.cmd("git", ["rev-parse", "--verify", "--quiet", "HEAD"])
    [source_ref: ref, main: "api-reference"]
  end
end
