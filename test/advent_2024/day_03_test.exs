defmodule Advent2024.Day03Test do
  use ExUnit.Case

  test "part 1" do
    example = "xmul(2,4)%&mul[3,7]!@^do_not_mul(5,5)+mul(32,64]then(mul(11,8)mul(8,5))"

    assert Advent2024.Day03.part_1(example) == 161
  end

  test "part 2" do
    example = "xmul(2,4)&mul[3,7]!^don't()_mul(5,5)+mul(32,64](mul(11,8)undo()?mul(8,5))"

    assert Advent2024.Day03.part_2(example) == 48
  end
end
