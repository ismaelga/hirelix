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

### Some benchmark results for the get command

```
$ hirelix ❯ mix bench
Settings:
  duration:      1.0 s
  mem stats:     false
  sys mem stats: false

[18:39:10] 1/2: GetBench.get Hirelix
[18:39:12] 2/2: GetBench.get Exredis
Finished in 9.68 seconds

GetBench.get Hirelix:      10000   225.88 µs/op
GetBench.get Exredis:       2000   3153.39 µs/op
```

