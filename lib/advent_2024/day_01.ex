defmodule Advent2024.Day01 do
  @moduledoc false

  @input Advent2024.get_input_for_day(1)

  def part_1(input \\ @input) do
    input
    |> parse_input()
    |> Tuple.to_list()
    |> Enum.map(&Enum.sort/1)
    |> Enum.zip()
    |> Enum.map(fn {a, b} -> abs(a - b) end)
    |> Enum.sum()
  end

  def part_2(input \\ @input) do
    {list_a, list_b} = parse_input(input)

    freqs = Enum.frequencies(list_b)

    list_a
    |> Enum.map(&(&1 * Map.get(freqs, &1, 0)))
    |> Enum.sum()
  end

  @spec parse_input(binary()) :: {[integer()], [integer()]}
  defp parse_input(txt) do
    txt
    |> String.split("\n", trim: true)
    |> Enum.map(fn line ->
      line
      |> String.split("   ")
      |> Enum.map(&String.to_integer/1)
      |> List.to_tuple()
    end)
    |> Enum.unzip()
  end
end
