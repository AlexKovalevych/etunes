defmodule Etunes.Mixfile do
    use Mix.Project

    def project do
        [app: :etunes,
         version: "0.0.1",
         elixir: "~> 1.2",
         elixirc_paths: elixirc_paths(Mix.env),
         build_embedded: Mix.env == :prod,
         start_permanent: Mix.env == :prod,
         deps: deps]
    end

    # Configuration for the OTP application
    #
    # Type "mix help compile.app" for more information
    def application do
        [mod: {Etunes, []},
         applications: [:logger, :httpotion, :httpoison]]
    end

    defp elixirc_paths(_), do: ["lib"]

    # Dependencies can be Hex packages:
    #
    #   {:mydep, "~> 0.3.0"}
    #
    # Or git/path repositories:
    #
    #   {:mydep, git: "https://github.com/elixir-lang/mydep.git", tag: "0.1.0"}
    #
    # Type "mix help deps" for more examples and options
    defp deps do
        [
            {:exprintf, "~> 0.1.6"},
            {:httpotion, "~> 3.0.0"},
            {:poison, "~> 2.0"},
            {:parallel_stream, "~> 1.0.5"},
            {:httpoison, "~> 0.9.0"}
        ]
    end
end
