defmodule Advent2024.Day06Test do
  use ExUnit.Case

  @example """
  ....#.....
  .........#
  ..........
  ..#.......
  .......#..
  ..........
  .#..^.....
  ........#.
  #.........
  ......#...
  """

  test "part 1" do
    assert Advent2024.Day06.part_1(@example) == 41
  end

  test "part 2" do
    assert Advent2024.Day06.part_2(@example) == 6
  end
end
