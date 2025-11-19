defmodule BreakCaesar do

  @freq_table [8.1, 1.5, 2.8, 4.2, 12.7, 2.2, 2.0, 6.1, 7.0,
               0.2, 0.8, 4.0, 2.4,  6.7, 7.5, 1.9, 0.1, 6,0,
               6.3, 9.0, 2.8, 1.0,  2.4, 0.2, 2.0, 0.1]

  @spec break(binary) :: binary
  def break(cipher) when is_binary(cipher) do
    key = 3
    Caesar.decode(cipher, key)
  end

  @spec percent(integer, integer) :: float
  def percent(n, m), do: (n / m) * 100

end
