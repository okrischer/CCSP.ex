defmodule Fibonacci do
  @moduledoc """
  Module `Fibonacci` provides some functions for computing
  the *Fibonacci sequence*.
  """

  @doc """
  Computes a Fibonacci number with *multiple recursion*,
  leading to an exponential running time.
  """
  @spec recursive(integer) :: integer
  def recursive(0), do: 0
  def recursive(1), do: 1
  def recursive(n), do: recursive(n-1) + recursive(n-2)

  @doc """
  Computes a Fibonacci number with *single recursion*,
  leading to a linear running time.
  The algorithm mimics an iterative approach.
  """
  @spec iterative(integer) :: integer
  def iterative(n), do: iter(0, 1, n)
  defp iter(a, _, 0), do: a
  defp iter(a, b, n), do: iter(b, a+b, n-1)

  @doc """
  Computes all Fibonacci numbers up to `n`, using an internal cache.
  The algorithm runs in linear time.
  """
  @spec memoize(integer) :: {integer, map}
  def memoize(n), do: calc_fib(%{0 => 0, 1 => 1}, n)

  defp calc_fib(cache, n) do
    case cache[n] do
      nil ->
        {n_1, cache} = calc_fib(cache, n-1)
        result = n_1 + cache[n-2]
        {result, Map.put(cache, n, result)}
      value ->
        {value, cache}
    end
  end

  @doc """
  Starts an `Agent` as a linked process, providing an initial cache.
  """
  @spec start_agent() :: {:ok, pid}
  def start_agent do
    Agent.start_link(fn -> %{0 => 0, 1 => 1} end)
  end

  @doc """
  Gets a Fibonacci number from an `Agent`.
  Running time is linear; if the searched value has been computed before,
  a call to `from_agent` results in a constant running time.
  """
  @spec from_agent(pid, integer) :: integer
  def from_agent(pid, n) when n >= 0 do
    Agent.get_and_update(pid, &calc_fib(&1, n))
  end

  @doc """
  Implements a *parallel map*, where the computation of each value
  is delegated to a separate process.
  """
  @spec pmap(list, fun) :: list
  def pmap(collection, fun) do
    me = self()
    collection
    |> Enum.map(fn e -> spawn_link(fn -> (send me, {self(), fun.(e)}) end) end)
    |> Enum.map(fn pid -> receive do {^pid, result} -> result end end)
  end
end
