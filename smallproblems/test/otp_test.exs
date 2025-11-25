defmodule OtpTest do
  use ExUnit.Case, async: true

  test "encrypting ascii works" do
    message = "This is a *test* with `digits` 123,\tand __punctuation__!\n"
    {cipher, key} = OTP.encrypt(message, :ascii)
    cleartext = OTP.decrypt(cipher, key)
    assert cleartext == "thisisatestwithdigitsandpunctuation"
  end

  test "encrypting unicode text works" do
    message = "This is a *test* with `digits` 123,\tand __punctuation__!\n"
    {cipher, key} = OTP.encrypt(message)
    cleartext = OTP.decrypt(cipher, key)
    assert cleartext == message
  end

  test "unicode codepoints are preserved" do
    message = "¿Hola, cómo estás?"
    {cipher, key} = OTP.encrypt(message)
    cleartext = OTP.decrypt(cipher, key)
    assert cleartext == message
  end

end
