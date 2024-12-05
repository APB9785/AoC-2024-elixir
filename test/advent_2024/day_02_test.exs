defmodule Advent2024.Day02Test do
  use ExUnit.Case

  @example_input """
  7 6 4 2 1
  1 2 7 8 9
  9 7 6 2 1
  1 3 2 4 5
  8 6 4 4 1
  1 3 6 7 9
  """

  test "part 1" do
    assert Advent2024.Day02.part_1(@example_input) == 2
  end

  test "part 2" do
    assert Advent2024.Day02.part_2(@example_input) == 4
  end
end
