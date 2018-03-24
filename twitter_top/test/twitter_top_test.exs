defmodule TwitterTopTest do
  use ExUnit.Case
  doctest TwitterTop

  test "greets the world" do
    assert TwitterTop.hello() == :world
  end
end
