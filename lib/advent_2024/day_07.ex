defmodule Advent2024.Day07 do
  @moduledoc false

  @input Advent2024.get_input_for_day(7)

  def part_1(input \\ @input) do
    input
    |> parse_input()
    |> Enum.filter(&can_be_true?(&1, :part_1))
    |> Enum.map(&elem(&1, 0))
    |> Enum.sum()
  end

  def part_2(input \\ @input) do
    input
    |> parse_input()
    |> Enum.filter(&can_be_true?(&1, :part_2))
    |> Enum.map(&elem(&1, 0))
    |> Enum.sum()
  end

  defp can_be_true?({res, values_list}, rules) do
    operator_count = length(values_list) - 1

    operators_str =
      case rules do
        :part_1 -> inspect([:*, :+])
        :part_2 -> inspect([:*, :+, :||])
      end

    operator_permutations =
      [
        "for ",
        for(i <- 1..operator_count, into: "", do: "p#{i} <- #{operators_str}, "),
        "do: [",
        for(i <- 1..(operator_count - 1)//1, into: "", do: "p#{i}, "),
        "p#{operator_count}]"
      ]
      |> Enum.join()
      |> Code.eval_string()
      |> elem(0)

    Enum.any?(operator_permutations, fn operators ->
      operate(tl(values_list), hd(values_list), operators) == res
    end)
  end

  defp operate([], n, _), do: n

  defp operate([y | n_rest], x, [op | op_rest]) do
    result =
      case op do
        :+ -> x + y
        :* -> x * y
        :|| -> String.to_integer("#{x}#{y}")
      end

    operate(n_rest, result, op_rest)
  end

  defp parse_input(txt) do
    txt
    |> String.split("\n", trim: true)
    |> Enum.map(fn line ->
      [res, values] = String.split(line, ": ")

      values_list =
        values
        |> String.split(" ")
        |> Enum.map(&String.to_integer/1)

      {String.to_integer(res), values_list}
    end)
  end
end
