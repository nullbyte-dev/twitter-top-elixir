defmodule TwitterGenstageTest do
  use ExUnit.Case
  doctest TwitterGenstage

  test "greets the world" do
    assert TwitterGenstage.hello() == :world
  end
end
