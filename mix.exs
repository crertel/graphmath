defmodule Graphmath.Mixfile do
  use Mix.Project

  def project do
    [
      app: :graphmath,
      version: "2.2.0",
      elixir: "~> 1.0",
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

  defp deps do
    [
      {:credo, "~> 1.0.3", only: :dev},
      {:dialyxir, "~> 1.0.0-rc.4", only: [:dev], runtime: false},
      {:ex_doc, "~> 0.19.3", only: [:dev, :docs]},
      {:excoveralls, "~> 0.10.0", only: [:test, :dev]},
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
