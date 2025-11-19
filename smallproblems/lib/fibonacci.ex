defmodule Fibonacci do

  @spec recursive(integer) :: integer
  def recursive(0), do: 0
  def recursive(1), do: 1
  def recursive(n), do: recursive(n-1) + recursive(n-2)

  @spec iterative(integer) :: integer
  def iterative(n), do: iter(0, 1, n)
  defp iter(a, _, 0), do: a
  defp iter(a, b, n), do: iter(b, a+b, n-1)

  @spec memoize(integer) :: {integer, map}
  def memoize(n), do: calc_fib(%{0 => 0, 1 => 1}, n)

  @spec calc_fib(map, integer) :: {integer, map}
  def calc_fib(cache, n) do
    case cache[n] do
      nil ->
        {n_1, cache} = calc_fib(cache, n-1)
        result = n_1 + cache[n-2]
        {result, Map.put(cache, n, result)}
      value ->
        {value, cache}
    end
  end

  @spec start_agent() :: {:ok, pid}
  def start_agent do
    Agent.start_link(fn -> %{0 => 0, 1 => 1} end)
  end

  @spec fib(pid, integer) :: integer
  def fib(pid, n) when n >= 0 do
    Agent.get_and_update(pid, &calc_fib(&1, n))
  end

  @spec pmap(list, fun) :: list
  def pmap(collection, fun) do
    me = self()
    collection
    |> Enum.map(fn e -> spawn_link(fn -> (send me, {self(), fun.(e)}) end) end)
    |> Enum.map(fn pid -> receive do {^pid, result} -> result end end)
  end
end
