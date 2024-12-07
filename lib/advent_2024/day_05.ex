defmodule Advent2024.Day05 do
  @moduledoc false

  @input Advent2024.get_input_for_day(5)

  def part_1(input \\ @input) do
    {rules_map, update_lists} = parse_input(input)

    update_lists
    |> Enum.filter(fn update_list ->
      update_list == Enum.sort_by(update_list, & &1, &(&2 in Map.get(rules_map, &1, [])))
    end)
    |> Enum.map(&get_middle_item/1)
    |> Enum.sum()
  end

  def part_2(input \\ @input) do
    {rules_map, update_lists} = parse_input(input)

    update_lists
    |> Enum.map(fn original ->
      sorted = Enum.sort_by(original, & &1, &(&2 in Map.get(rules_map, &1, [])))
      if sorted != original, do: sorted
    end)
    |> Enum.reject(&is_nil/1)
    |> Enum.map(&get_middle_item/1)
    |> Enum.sum()
  end

  defp parse_input(txt) do
    [rules, updates] = String.split(txt, "\n\n")

    parsed_rules =
      rules
      |> String.split("\n")
      |> Enum.map(fn line ->
        line
        |> String.split("|")
        |> Enum.map(&String.to_integer/1)
        |> List.to_tuple()
      end)
      |> Enum.group_by(&elem(&1, 0), &elem(&1, 1))

    parsed_updates =
      updates
      |> String.split("\n", trim: true)
      |> Enum.map(fn line ->
        line
        |> String.split(",")
        |> Enum.map(&String.to_integer/1)
      end)

    {parsed_rules, parsed_updates}
  end

  defp get_middle_item(list), do: Enum.at(list, div(length(list), 2))
end
