defmodule SupTest do
  use ExUnit.Case
  doctest Sup

  test "greets the world" do
    assert Sup.hello() == :world
  end
end
