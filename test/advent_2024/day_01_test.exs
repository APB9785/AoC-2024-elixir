defmodule Advent2024.Day01Test do
  use ExUnit.Case

  @example_input """
  3   4
  4   3
  2   5
  1   3
  3   9
  3   3
  """

  test "part 1" do
    assert Advent2024.Day01.part_1(@example_input) == 11
  end

  test "part 2" do
    assert Advent2024.Day01.part_2(@example_input) == 31
  end
end
