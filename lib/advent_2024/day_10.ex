defmodule Advent2024.Day10 do
  @moduledoc false

  @input Advent2024.get_input_for_day(10)

  def part_1(input \\ @input) do
    input
    |> parse_input()
    |> Map.put(:rules, :part_1)
    |> score_trailheads()
  end

  def part_2(input \\ @input) do
    input
    |> parse_input()
    |> Map.put(:rules, :part_2)
    |> score_trailheads()
  end

  defp score_trailheads(state) do
    %{graph: graph, trailheads: trailheads, rules: rules} = state

    trailheads
    |> Enum.map(&traverse_graph([&1], 0, graph, rules))
    |> Enum.sum()
  end

  defp traverse_graph([], _, _, _), do: 0
  defp traverse_graph(coords, 9, _, _), do: length(coords)

  defp traverse_graph(coords, height, graph, rules) do
    next_coords =
      coords
      |> Enum.flat_map(&graph[&1])
      |> then(&if(rules == :part_1, do: Enum.uniq(&1), else: &1))

    traverse_graph(next_coords, height + 1, graph, rules)
  end

  defp parse_input(txt) do
    map =
      txt
      |> String.graphemes()
      |> build_map(0, 0, %{})

    %{
      graph: build_graph(map),
      trailheads: trailhead_coords(map)
    }
  end

  defp build_map(["\n"], _, _, map), do: map
  defp build_map(["\n" | t], _, y, map), do: build_map(t, 0, y + 1, map)
  defp build_map([h | t], x, y, map), do: build_map(t, x + 1, y, Map.put(map, {x, y}, String.to_integer(h)))

  defp build_graph(map) do
    Enum.reduce(map, %{}, fn {coord, height}, graph ->
      reachable = Enum.filter(neighbors(coord), fn neighbor -> Map.get(map, neighbor) == height + 1 end)
      Map.put(graph, coord, reachable)
    end)
  end

  defp neighbors({x, y}) do
    [
      {x + 1, y},
      {x - 1, y},
      {x, y + 1},
      {x, y - 1}
    ]
  end

  defp trailhead_coords(map) do
    map
    |> Enum.filter(fn {_coord, height} -> height == 0 end)
    |> Enum.map(&elem(&1, 0))
  end
end
