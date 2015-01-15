defmodule Graphmath.Mixfile do
  use Mix.Project

  def project do
    [app: :graphmath,
     version: "0.4.3",
     elixir: "~> 1.0",
     description: description,
     package: package,
     deps: deps]
  end

  def application, do: []

  defp description do
    """
    Graphmath is a library for doing 2D and 3D mathemtical operations.
    """
  end

  defp deps do
    [
        {:earmark, "~> 0.1", only: :dev },
        {:ex_doc, "~> 0.6", only: :dev}
    ]
  end

  defp package do
    [
      contributors: ["Chris Ertel"],
      licenses: ["Public Domain (unlicense)", "WTFPL", "New BSD"],
      links: %{"GitHub" => "https://github.com/crertel/graphmath"}
    ]
  end

end

