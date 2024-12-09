defmodule Advent2024.Day08 do
  @moduledoc false

  @input Advent2024.get_input_for_day(8)

  def part_1(input \\ @input) do
    input
    |> parse_input()
    |> Map.put(:rules, :part_1)
    |> count_antinodes()
  end

  def part_2(input \\ @input) do
    input
    |> parse_input()
    |> Map.put(:rules, :part_2)
    |> count_antinodes()
  end

  defp count_antinodes(state) do
    state.antennas
    |> Enum.flat_map(&make_antinodes(&1, state))
    |> MapSet.new()
    |> MapSet.size()
  end

  defp make_antinodes({_freq, coords}, state) do
    coords
    |> all_possible_pairs()
    |> Enum.flat_map(&antinodes_for_pair(&1, state))
  end

  defp all_possible_pairs(coords) do
    for a <- coords,
        b <- coords,
        a != b,
        do: {a, b}
  end

  defp antinodes_for_pair({{x1, y1}, {x2, y2}}, %{rules: :part_1} = state) do
    dx = x2 - x1
    dy = y2 - y1
    locations = [{x1 - dx, y1 - dy}, {x2 + dx, y2 + dy}]

    Enum.filter(locations, &within_bounds?(&1, state))
  end

  defp antinodes_for_pair({{x1, y1}, {x2, y2}}, %{rules: :part_2} = state) do
    dx = x2 - x1
    dy = y2 - y1

    direction_1 =
      {x1, y1}
      |> Stream.iterate(fn {x, y} -> {x - dx, y - dy} end)
      |> Enum.take_while(&within_bounds?(&1, state))

    direction_2 =
      {x2, y2}
      |> Stream.iterate(fn {x, y} -> {x + dx, y + dy} end)
      |> Enum.take_while(&within_bounds?(&1, state))

    direction_1 ++ direction_2
  end

  defp within_bounds?({x, y} = _coord, %{bounds: {xx, yy}}),
    do: x >= 0 and y >= 0 and x <= xx and y <= yy

  defp parse_input(txt) do
    txt
    |> String.graphemes()
    |> parse_input(0, 0, %{antennas: %{}})
  end

  defp parse_input(["\n"], x, y, state), do: Map.put(state, :bounds, {x - 1, y})
  defp parse_input(["\n" | t], _x, y, state), do: parse_input(t, 0, y + 1, state)
  defp parse_input(["." | t], x, y, state), do: parse_input(t, x + 1, y, state)
  defp parse_input([freq | t], x, y, state), do: parse_input(t, x + 1, y, put_antenna(state, {x, y}, freq))

  defp put_antenna(state, coord, freq) do
    Map.update!(state, :antennas, fn antennas ->
      Map.update(antennas, freq, [coord], &[coord | &1])
    end)
  end
end
