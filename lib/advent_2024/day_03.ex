defmodule Advent2024.Day03 do
  @moduledoc false

  @input Advent2024.get_input_for_day(3)
  @init_state %{mul_enabled: true, sum_total: 0}

  def part_1(input \\ @input) do
    input
    |> scan_for_valid_instructions()
    |> Enum.map(&parse_instruction/1)
    # Part 2 instructions will be included by the regex + parser
    # therefore we need to filter only the part 1 functions
    |> Enum.filter(&part_1_function?/1)
    |> Enum.reduce(@init_state, &execute_instruction/2)
    |> Map.fetch!(:sum_total)
  end

  def part_2(input \\ @input) do
    input
    |> scan_for_valid_instructions()
    |> Enum.map(&parse_instruction/1)
    |> Enum.reduce(@init_state, &execute_instruction/2)
    |> Map.fetch!(:sum_total)
  end

  defp scan_for_valid_instructions(input) do
    Regex.scan(
      ~r/
      (mul\(\d{1,3},\d{1,3}\)) # mul - multiply two numbers
      |(do\(\))                # do  - enable future mul instructions
      |(don't\(\))             # dont - disable future mul instructions
      /x,
      input
    )
  end

  defp parse_instruction(["mul(" <> instruction | _]) do
    [a, b] =
      instruction
      |> String.trim_trailing(")")
      |> String.split(",")
      |> Enum.map(&String.to_integer/1)

    {:mul, a, b}
  end

  defp parse_instruction(["do()" | _]), do: {:do}
  defp parse_instruction(["don't()" | _]), do: {:dont}

  defp execute_instruction({:mul, a, b}, state) do
    if state.mul_enabled,
      do: Map.update!(state, :sum_total, &(a * b + &1)),
      else: state
  end

  defp execute_instruction({:do}, state), do: Map.put(state, :mul_enabled, true)
  defp execute_instruction({:dont}, state), do: Map.put(state, :mul_enabled, false)

  defp part_1_function?({:mul, _, _}), do: true
  defp part_1_function?(_), do: false
end
