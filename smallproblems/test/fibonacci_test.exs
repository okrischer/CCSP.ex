defmodule FibonacciTest do
  use ExUnit.Case, async: true

  test "recursive works" do
    assert Fibonacci.recursive(10) == 55
  end

  test "iterative works" do
    assert Fibonacci.iterative(10) == 55
  end

  test "memoize works" do
    {result, cache} = Fibonacci.memoize(10)
    assert result == 55
    assert Map.to_list(cache) |> length == 11
  end

  test "from_agent works" do
    {:ok, pid} = Fibonacci.start_agent()
    assert Fibonacci.from_agent(pid, 10) == 55
  end

  test "pmap works" do
    result = Fibonacci.pmap(1..5, &(&1 * &1))
    assert result == [1, 4, 9, 16, 25]
  end

end
