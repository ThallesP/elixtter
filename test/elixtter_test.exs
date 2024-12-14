defmodule ElixtterTest do
  use ExUnit.Case
  doctest Elixtter

  test "greets the world" do
    assert Elixtter.hello() == :world
  end
end
