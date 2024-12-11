defmodule Advent2024.Day10Test do
  use ExUnit.Case

  @example """
  89010123
  78121874
  87430965
  96549874
  45678903
  32019012
  01329801
  10456732
  """

  test "part 1" do
    assert Advent2024.Day10.part_1(@example) == 36
  end

  test "part 2" do
    assert Advent2024.Day10.part_2(@example) == 81
  end
end
