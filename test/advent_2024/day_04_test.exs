defmodule Advent2024.Day04Test do
  use ExUnit.Case

  @example """
  MMMSXXMASM
  MSAMXMSMSA
  AMXSXMAAMM
  MSAMASMSMX
  XMASAMXAMM
  XXAMMXXAMA
  SMSMSASXSS
  SAXAMASAAA
  MAMMMXMMMM
  MXMXAXMASX
  """

  test "part 1" do
    assert Advent2024.Day04.part_1(@example) == 18
  end

  test "part 2" do
    assert Advent2024.Day04.part_2(@example) == 9
  end
end
