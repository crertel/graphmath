defmodule Graphmath.Mixfile do
  use Mix.Project

  def project do
    [app: :graphmath,
     version: "1.0.0",
     elixir: "~> 1.0",
     description: description,
     package: package,
     docs: &docs/0,
     deps: deps,
     test_coverage: [tool: ExCoveralls]
     ]
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
        {:ex_doc, "~> 0.6", only: :dev},
        {:excoveralls, "~> 0.3", only: :dev},
        {:inch_ex, "~> 0.2",  only: :docs}
    ]
  end

  defp package do
    [
      contributors: ["Chris Ertel", "Ivan Miranda"],
      licenses: ["Public Domain (unlicense)", "WTFPL", "New BSD"],
      links: %{"GitHub" => "https://github.com/crertel/graphmath"}
    ]
  end

  defp docs do
    {ref, 0} = System.cmd("git", ["rev-parse", "--verify", "--quiet", "HEAD"])
    [ source_ref: ref,
     main: "overview"]
  end

end

