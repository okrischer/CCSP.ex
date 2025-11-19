defmodule Caesar do

  @spec encode(binary, integer) :: binary | :ok
  def encode(plaintext, key) when is_binary(plaintext) do
    charlist = plaintext
      |> String.trim
      |> String.upcase
      |> String.to_charlist
    if List.ascii_printable?(charlist) do
      charlist
      |> Enum.map(fn char -> shift(char, key) end)
      |> List.to_string
      |> String.replace("/", "")
    else
      IO.puts("Cannot encode #{charlist}.")
    end
  end

  def encode(_something, _key) do
    IO.puts("Cannot encode something else than strings.")
  end

  @spec decode(binary, integer) :: binary
  def decode(cipher, key), do: encode(cipher, -key) |> String.downcase

  @spec shift(integer, integer) :: integer
  def shift(char, key) do
    if char >= ?A and char <= ?Z do
      norm = char - ?A
      Integer.mod(norm + key, 26) + ?A
    else
      ?/
    end
  end

end
