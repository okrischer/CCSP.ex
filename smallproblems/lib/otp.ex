defmodule OTP do
  @moduledoc """
  Module `OTP` contains functions for encrypting / decrypting
  a *one-time pad* encryption.
  """

  import Bitwise

  ########################### encrypt ###############################

  @doc """
  Encrypts a given string with *one-time pad* encryption.

  If no `format` is given, `format` defaults to `:unicode`.
  In this case, all characters are preserved,
  and the original message can be fully restored.

  If `format` is set to `:ascii` only *letters* are encypted.
  This is the original usecase for *one-time pad* encryption,
  allowing to express the secret key and the cipher as a `String`.
  """
  @spec encrypt(binary) :: {binary, binary}
  def encrypt(plaintext, format \\ :unicode)

  @spec encrypt(binary, atom) :: {binary, binary}
  def encrypt(plaintext, _format = :ascii) do
    cleaned = plaintext
      |> String.replace(~r/[^[:alpha:]]/, "")
      |> String.upcase
    encrypt_ascii(cleaned)
  end

  def encrypt(plaintext, _format) do
    encrypt_unicode(plaintext, <<>>, <<>>)
  end

  defp encrypt_ascii(message) do
    msg = String.to_charlist(message)
    key = random_letters(length(msg))
    cipher = for {m, k} <- Enum.zip(msg, key) do
      Integer.mod((m-?A) + (k-?A), 26) + ?A
    end
    {List.to_string(cipher), List.to_string(key)}
  end

  defp random_letters(0), do: []
  defp random_letters(n) do
    letter = :rand.uniform(25) + ?A
    [letter | random_letters(n-1)]
  end

  defp encrypt_unicode(<<>>, cipher, key), do: {cipher, key}
  defp encrypt_unicode(<<m, rest::binary>>, cipher, key) do
    k = :rand.uniform(255)
    c = bxor(m, k)
    encrypt_unicode(rest, <<c>> <> cipher, <<k>> <> key)
  end



  ########################### decrypt ###############################

  @doc """
  Decrypts a `cipher` with a given `key`.

  If the `cipher` is a valid string, it will be decoded with `decrypt_ascii`,
  otherwise with `decrypt_unicode`.
  """
  @spec decrypt(binary, binary) :: binary
  def decrypt(cipher, key) do
    if String.valid?(cipher) do
      decrypt_ascii(cipher, key)
    else
      decrypt_unicode(cipher, <<>>, key)
    end
  end

  defp decrypt_ascii(cipher, key) do
    cip = String.to_charlist(cipher)
    key = String.to_charlist(key)
    cleartext = for {c, k} <- Enum.zip(cip, key) do
      Integer.mod((c-?A) - (k-?A), 26) + ?A
    end
    cleartext |> List.to_string() |> String.downcase
  end

  defp decrypt_unicode(<<>>, message, _key), do: message
  defp decrypt_unicode(<<c, cipher::binary>>, message, <<k, key::binary>>) do
    m = bxor(c, k)
    decrypt_unicode(cipher, <<m>> <> message, key)
  end
end
