defmodule Advent2024.Day04 do
  @moduledoc false

  @input Advent2024.get_input_for_day(4)
  @directions [:ne, :n, :nw, :e, :w, :se, :s, :sw]
  @next_char %{"X" => "M", "M" => "A", "A" => "S"}

  def part_1(input \\ @input) do
    input
    |> parse_input()
    |> count_xmas()
  end

  defp count_xmas(map) do
    map
    |> Map.keys()
    |> Enum.map(&count_xmas(&1, map))
    |> Enum.sum()
  end

  defp count_xmas(coord, map) do
    if Map.fetch!(map, coord) == "X" do
      @directions
      |> Enum.filter(&search?(&1, coord, map, "X"))
      |> Enum.count()
    else
      0
    end
  end

  defp search?(_, _, _, "S"), do: true

  defp search?(direction, {x, y}, map, prev) do
    looking_for = Map.fetch!(@next_char, prev)

    looking_at =
      case direction do
        :ne -> {x + 1, y - 1}
        :n -> {x, y - 1}
        :nw -> {x - 1, y - 1}
        :e -> {x + 1, y}
        :w -> {x - 1, y}
        :se -> {x + 1, y + 1}
        :s -> {x, y + 1}
        :sw -> {x - 1, y + 1}
      end

    if Map.get(map, looking_at) == looking_for,
      do: search?(direction, looking_at, map, looking_for),
      else: false
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
