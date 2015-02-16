defmodule Hirelix do
  defmacro __using__(_opts) do
    quote do
      import Hirelix
      import Exredis, except: [
        start: 0,
        start_link: 5,
        stop: 1,
        query: 2
      ]
    end
  end

  def start(host \\ "127.0.0.1", port \\ 6379, database \\ 0,
            password \\ "", reconnect_sleep \\ :no_reconnect), do:
    start_link(host, port, database, password, reconnect_sleep)
    |> elem 1

  @type reconnect_sleep :: :no_reconnect | integer
  @type start_link      :: { :ok, pid } | { :error, term }

  def start_link(host \\ "127.0.0.1", port \\ 6379, database \\ 0, password \\ "", reconnect_sleep \\ :no_reconnect) do
    :hierdis.connect(String.to_char_list(host), port)
  end

  @spec query(pid, list) :: any
  def query(client, command) when is_list(command) do
    command = command |> Enum.map(&to_char_list/1)
    client |> :hierdis.command(command) |> elem(1)
  end

  @spec query_pipe(pid, [list]) :: any
  def query_pipe(client, command) when is_list(command), do:
    client |> :hierdis.pipeline(command)
end
