defmodule Hirelix.Mixfile do
  use Mix.Project

  def project do
    [app: :hirelix,
     version: "0.0.1",
     elixir: "~> 1.0",
     deps: deps]
  end

  def application do
    [applications: [:logger]]
  end

  defp deps do
    [
      {:exredis, github: "artemeff/exredis", tag: "0.1.0"},
      {:hierdis, github: "ismaelga/hierdis", branch: "async-tests"},
    ]
  end
end
