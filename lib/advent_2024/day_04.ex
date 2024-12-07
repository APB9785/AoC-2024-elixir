defmodule Advent2024.Day04 do
  @moduledoc false

  @input Advent2024.get_input_for_day(4)
  @directions [:ne, :n, :nw, :e, :w, :se, :s, :sw]

  def part_1(input \\ @input) do
    input
    |> parse_input()
    |> count_matches(simple_conditions("XMAS"))
  end

  def part_2(input \\ @input) do
    input
    |> parse_input()
    |> count_matches(part_2_conditions())
  end

  # searches one word in a straight line in any direction
  defp simple_conditions(word) do
    for d <- @directions do
      [
        {:origin, String.at(word, 0)}
        | for(i <- 1..(String.length(word) - 1), do: {d, i, String.at(word, i)})
      ]
    end
  end

  # searches for two "MAS" words in the shape of an X
  defp part_2_conditions do
    [
      [{:origin, "A"}, {:nw, 1, "M"}, {:ne, 1, "S"}, {:sw, 1, "M"}, {:se, 1, "S"}],
      [{:origin, "A"}, {:nw, 1, "M"}, {:ne, 1, "M"}, {:sw, 1, "S"}, {:se, 1, "S"}],
      [{:origin, "A"}, {:nw, 1, "S"}, {:ne, 1, "S"}, {:sw, 1, "M"}, {:se, 1, "M"}],
      [{:origin, "A"}, {:nw, 1, "S"}, {:ne, 1, "M"}, {:sw, 1, "S"}, {:se, 1, "M"}]
    ]
  end

  defp count_matches(map, conditions) do
    map
    |> Map.keys()
    |> Enum.map(fn coord -> Enum.count(conditions, &conditions_met?(&1, coord, map)) end)
    |> Enum.sum()
  end

  defp conditions_met?(condition_set, coord, map) do
    Enum.all?(condition_set, &condition_met?(&1, coord, map))
  end

  defp condition_met?({:origin, char}, coord, map) do
    Map.get(map, coord) == char
  end

  defp condition_met?({direction, distance, char}, {x, y}, map) do
    coord =
      case direction do
        :ne -> {x + distance, y - distance}
        :n -> {x, y - distance}
        :nw -> {x - distance, y - distance}
        :e -> {x + distance, y}
        :w -> {x - distance, y}
        :se -> {x + distance, y + distance}
        :s -> {x, y + distance}
        :sw -> {x - distance, y + distance}
      end

    Map.get(map, coord) == char
  end

  defp parse_input(txt) do
    txt
    |> String.graphemes()
    |> parse_input(0, 0, %{})
  end

  defp parse_input([], _, _, res), do: res
  defp parse_input(["\n" | t], _, y, res), do: parse_input(t, 0, y + 1, res)
  defp parse_input([h | t], x, y, res), do: parse_input(t, x + 1, y, Map.put(res, {x, y}, h))
end
