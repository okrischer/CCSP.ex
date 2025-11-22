defmodule CaesarTest do
  use ExUnit.Case, async: true
  doctest Caesar

  test "encoding works" do
    cipher = Caesar.encode("Elixir", 3)
    assert ^cipher = "HOLALU"
  end

  test "decoding works" do
    cleartext = Caesar.decode("HOLALU", 3)
    assert ^cleartext = "elixir"
  end

  test "shifting works" do
    assert Caesar._shift(?Y, 3) == 66
  end

  test "breaking works" do
    cipher = Caesar.encode("Functional programming is fun!", 7)
    cleartext = Caesar.break(cipher)
    assert ^cleartext = "functionalprogrammingisfun"
  end
end
