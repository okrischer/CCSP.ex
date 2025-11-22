defmodule Caesar do
  @moduledoc """
  Module `Caesar` provides functions for encoding and decoding
  *Caesar's Cipher*, as well as functions to break the cipher.
  """

  @expected [8.1, 1.5, 2.8, 4.2, 12.7, 2.2, 2.0, 6.1, 7.0,
             0.2, 0.8, 4.0, 2.4,  6.7, 7.5, 1.9, 0.1, 6.0,
             6.3, 9.0, 2.8, 1.0,  2.4, 0.2, 2.0, 0.1]


  ####################### encode / decode #############################

  @doc """
  Encodes a string by shifting every letter `key` positions down
  the alphabet.
  Prints an error message if the given argument cannot be encoded.
  """
  @spec encode(binary, integer) :: binary | :ok
  def encode(plaintext, key) when is_binary(plaintext) do
    charlist = plaintext
      |> String.trim
      |> String.upcase
      |> String.to_charlist
    if List.ascii_printable?(charlist) do
      charlist
      |> Enum.map(fn char -> _shift(char, key) end)
      |> List.to_string
      |> String.replace("/", "")
    else
      IO.puts("Cannot encode #{charlist}.")
    end
  end

  def encode(_something, _key) do
    IO.puts("Cannot encode something else than strings.")
  end

  @doc """
  Decodes a cipher with a given `key`.
  """
  @spec decode(binary, integer) :: binary
  def decode(cipher, key), do: encode(cipher, -key) |> String.downcase

  @spec _shift(integer, integer) :: integer
  def _shift(char, key) do
    if char >= ?A and char <= ?Z do
      norm = char - ?A
      Integer.mod(norm + key, 26) + ?A
    else
      ?/
    end
  end

  ###################### break the cipher #############################

  @doc """
  Breaks a *Caesar cipher* without knowing the *key*.
  """
  @spec break(binary) :: binary
  def break(cipher) when is_binary(cipher) do
    observed = _frequencies(cipher)
    chi_stats = for n <- 0..25 do
      _chi_square(_rotate(observed, n), @expected)
    end
    key = Enum.find_index(chi_stats, &(&1 == Enum.min(chi_stats)))
    decode(cipher, key)
  end

  @spec _frequencies(binary) :: [float]
  def _frequencies(text) do
    charlist = String.to_charlist(text)
    m = length(charlist)
    for c <- ?A..?Z do
      n = Enum.count(charlist, &(&1 == c))
      (n / m) * 100
    end
  end

  @spec _chi_square([float], [float]) :: float
  def _chi_square(observed, expected) do
    data = for {o, e} <- Enum.zip(observed, expected) do
      Float.pow(o-e, 2) / e
    end
    Enum.sum(data)
  end

  @spec _rotate([float], integer) :: [float]
  def _rotate(collection, n) do
    Enum.drop(collection, n) ++ Enum.take(collection, n)
  end

end
