defmodule Advent2024.Day02 do
  @moduledoc false

  @input Advent2024.get_input_for_day(2)

  def part_1(input \\ @input) do
    input
    |> parse_input()
    |> Enum.count(&safe?/1)
  end

  def part_2(input \\ @input) do
    input
    |> parse_input()
    |> Enum.map(&[&1 | for(i <- 0..(length(&1) - 1), do: List.delete_at(&1, i))])
    |> Enum.count(fn possibilities -> Enum.any?(possibilities, &safe?/1) end)
  end

  defp parse_input(txt) do
    txt
    |> String.split("\n", trim: true)
    |> Enum.map(fn line ->
      line
      |> String.split(" ")
      |> Enum.map(&String.to_integer/1)
    end)
  end

  defp safe?([a | [b | _] = t]) do
    case b - a do
      n when n == 0 or n > 3 or n < -3 -> false
      n -> safe?(t, n)
    end
  end

  defp safe?([_], _), do: true

  defp safe?([a | [b | _] = t], prev) do
    case b - a do
      n when n == 0 or n > 3 or n < -3 -> false
      n when n > 0 -> prev > 0 && safe?(t, n)
      n when n < 0 -> prev < 0 && safe?(t, n)
    end
  end
end
