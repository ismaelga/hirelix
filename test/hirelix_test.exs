defmodule HiPi do
  use Hirelix

  def get, do: start |> query ["GET", "Pi"]
  def set, do: start |> query ["SET", "Pi", "3.14"]
end

defmodule HirelixTest do
  use ExUnit.Case
  alias Hirelix, as: E

  setup do
    client = E.start

    # clean up database and set test value
    client |> E.query ["FLUSHALL"]
    client |> E.query ["SET", "key", "value"]

    { :ok, [c: client] }
  end

  test "simple" do
    assert HiPi.set == "OK"
    assert HiPi.get == "3.14"
  end

  test "connect, erlang way" do
    { :ok, pid } = E.start_link
  end

  test "connect using connection string" do
    assert E.start_using_connection_string("redis://127.0.0.1:6379")
  end

  test "disconnect" do
    assert (E.start |> E.stop) == :ok
  end

  test "set returns OK", ctx do
    assert (ctx[:c] |> E.query ["SET", "foo", "bar"]) == "OK"
  end

  test "set works", ctx do
    ctx[:c] |> E.query ["SET", "foo", "bar"]

    assert (ctx[:c] |> E.query ["GET", "foo"]) == "bar"
  end

  test "get", ctx do
    assert (ctx[:c] |> E.query ["GET", "key"]) == "value"
  end

  test "mset returns OK", ctx do
    values = ["key1", "value1", "key2", "value2"]

    assert (ctx[:c] |> E.query ["MSET" | values]) == "OK"
  end

  test "mset works", ctx do
    ctx[:c] |> E.query ["MSET" | ["key1", "value1", "key2", "value2"]]

    values = ctx[:c] |> E.query ["MGET" | ["key1", "key2"]]

    assert values == ["value1", "value2"]
  end

  test "transactions" do
    client = E.start

    status = E.query(client, ["MULTI"])
    assert status == "OK"

    status = E.query(client, ["SET", "foo", "bar"])
    assert status == "QUEUED"

    status = E.query(client, ["SET", "bar", "baz"])
    assert status == "QUEUED"

    status = E.query(client, ["EXEC"])
    assert status == ["OK", "OK"]

    values = E.query(client, ["MGET" | ["foo", "bar"]])
    assert values == ["bar", "baz"]
  end

  test "pipelining" do
    query  = [["SET", :a, "1"], ["LPUSH", :b, "3"], ["LPUSH", :b, "2"]]
    client = E.start

    status = E.query_pipe(client, query)
    assert status == [ok: "OK", ok: "1", ok: "2"]
  end
end
