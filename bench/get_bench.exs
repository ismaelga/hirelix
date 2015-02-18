defmodule GetBench do
  use Benchfella

  defmodule Pi do
    use Exredis

    def get, do: start |> query ["GET", "Pi"]
    def set, do: start |> query ["SET", "Pi", "3.14"]
  end

  defmodule HiPi do
    use Hirelix

    def get, do: start |> query ["GET", "Pi"]
    def set, do: start |> query ["SET", "Pi", "3.14"]
  end

  bench "get Exredis" do
    Pi.get
  end

  bench "get Hirelix" do
    HiPi.get
  end
end
