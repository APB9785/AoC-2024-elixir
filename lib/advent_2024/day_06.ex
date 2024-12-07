defmodule Advent2024.Day06 do
  @moduledoc false

  @input Advent2024.get_input_for_day(6)
  @init_state %{guard: nil, obstacles: MapSet.new(), bounds: nil, history: MapSet.new(), finish: nil}
  @next_direction %{north: :east, east: :south, south: :west, west: :north}

  def part_1(input \\ @input) do
    input
    |> parse_input()
    |> travel_until_out_of_bounds_or_looped()
    |> Map.fetch!(:history)
    |> Enum.uniq_by(fn {_dir, x, y} -> {x, y} end)
    |> length()
  end

  def part_2(input \\ @input) do
    state = parse_input(input)

    input
    |> parse_input()
    # run once to see what path the guard takes
    |> travel_until_out_of_bounds_or_looped()
    |> Map.fetch!(:history)
    |> Enum.map(fn {_dir, x, y} -> {x, y} end)
    |> Enum.uniq()
    # these coords are the useful targets for placing an obstacle to create a loop
    |> Enum.map(fn coord ->
      Task.async(fn ->
        state
        |> put_obstacle(coord)
        |> travel_until_out_of_bounds_or_looped()
      end)
    end)
    # using Task not only runs faster, but also prevents memory use from growing too much
    |> Task.await_many(:infinity)
    |> Enum.count(&(&1.finish == :looped))
  end

  defp travel_until_out_of_bounds_or_looped(state) do
    %{guard: %{pos: {x, y}}, bounds: {xx, yy}} = updated_state = advance_guard(state)

    cond do
      x < 0 or x > xx or y < 0 or y > yy ->
        Map.put(updated_state, :finish, :out_of_bounds)

      updated_state.finish == :looped ->
        updated_state

      :otherwise ->
        travel_until_out_of_bounds_or_looped(updated_state)
    end
  end

  defp advance_guard(state) do
    %{guard: %{pos: {x, y}, dir: guard_direction}, obstacles: obstacles} = state

    to_step =
      case guard_direction do
        :north -> {x, y - 1}
        :east -> {x + 1, y}
        :south -> {x, y + 1}
        :west -> {x - 1, y}
      end

    if MapSet.member?(obstacles, to_step) do
      state
      |> Map.update!(:guard, &Map.put(&1, :dir, @next_direction[guard_direction]))
      |> advance_guard()
    else
      updated_state = Map.update!(state, :guard, &Map.put(&1, :pos, to_step))

      if MapSet.member?(updated_state.history, {guard_direction, x, y}) do
        Map.put(updated_state, :finish, :looped)
      else
        Map.update!(updated_state, :history, &MapSet.put(&1, {guard_direction, x, y}))
      end
    end
  end

  defp parse_input(txt) do
    txt
    |> String.graphemes()
    |> parse_input(0, 0, @init_state)
  end

  defp parse_input(["\n"], x, y, state), do: Map.put(state, :bounds, {x, y})
  defp parse_input(["\n" | t], _, y, state), do: parse_input(t, 0, y + 1, state)
  defp parse_input(["." | t], x, y, state), do: parse_input(t, x + 1, y, state)
  defp parse_input(["#" | t], x, y, state), do: parse_input(t, x + 1, y, put_obstacle(state, {x, y}))
  defp parse_input(["^" | t], x, y, state), do: parse_input(t, x + 1, y, put_guard(state, {x, y}))

  defp put_obstacle(state, coord), do: Map.update!(state, :obstacles, &MapSet.put(&1, coord))

  defp put_guard(state, coord), do: Map.put(state, :guard, %{pos: coord, dir: :north})
end
