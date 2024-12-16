defmodule Advent2024.Day11 do
  @moduledoc false

  @input Advent2024.get_input_for_day(11)

  def part_1(input \\ @input) do
    input
    |> parse_input()
    |> blinks(25)
    |> Map.values()
    |> Enum.sum()
  end

  def part_2(input \\ @input) do
    input
    |> parse_input()
    |> blinks(75)
    |> Map.values()
    |> Enum.sum()
  end

  defp blinks(stones, 0), do: stones

  defp blinks(stones, remaining) do
    stones
    |> Enum.map(fn {num, qty} ->
      cond do
        num == 0 -> %{1 => qty}
        even_digits?(num) -> Map.merge(%{left(num) => qty}, %{right(num) => qty}, fn _k, v1, v2 -> v1 + v2 end)
        :otherwise -> %{(num * 2024) => qty}
      end
    end)
    |> Enum.reduce(&Map.merge(&2, &1, fn _k, v1, v2 -> v1 + v2 end))
    |> blinks(remaining - 1)
  end

  defp even_digits?(num) do
    num
    |> Integer.digits()
    |> length()
    |> rem(2)
    |> Kernel.==(0)
  end

  defp left(num) do
    digits = Integer.digits(num)

    digits
    |> Enum.take(div(length(digits), 2))
    |> Integer.undigits()
  end

  defp right(num) do
    digits = Integer.digits(num)

    digits
    |> Enum.drop(div(length(digits), 2))
    |> Integer.undigits()
  end

  defp parse_input(txt) do
    txt
    |> String.trim()
    |> String.split(" ")
    |> Enum.map(&String.to_integer/1)
    |> Enum.frequencies()
  end
end
