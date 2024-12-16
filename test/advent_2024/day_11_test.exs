defmodule Advent2024.Day11Test do
  use ExUnit.Case

  @example """
  125 17
  """

  test "part 1" do
    assert Advent2024.Day11.part_1(@example) == 55312
  end
end
