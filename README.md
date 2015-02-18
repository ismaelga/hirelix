Hirelix
=======

** WARNING: Broken software ahead... **

This is just an experiment on using hiredis on Elixir.

It's a kinda of an extension to `exredis` to get the speed of hiredis using erlang bindings for it (hierdis).

To use it you have to add it to your project dependencies.

```elixir
{:exredis, github: "artemeff/exredis", tag: "0.1.0"},
{:hirelix, github: "ismaelga/hirelix"}
```

Then replace `use Exredis` with `use Hirelix`
```elixir
defmodule Pi do
  use Exredis

  def get, do: start |> query ["GET", "Pi"]
  def set, do: start |> query ["SET", "Pi", "3.14"]
end
```

would become

```elixir
defmodule Pi do
  use Hirelix

  def get, do: start |> query ["GET", "Pi"]
  def set, do: start |> query ["SET", "Pi", "3.14"]
end
```
