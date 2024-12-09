defmodule Advent2024.Day09 do
  @moduledoc false

  @input Advent2024.get_input_for_day(9)

  def part_1(input \\ @input) do
    input
    |> parse_input()
    |> compact_data()
    |> calculate_checksum()
  end

  defp parse_input(txt) do
    state = %{type: :file, index: 0, id: 0, blocks: %{}, free: [], file: []}

    txt
    |> String.trim()
    |> String.graphemes()
    |> expand_data(state)
    |> Map.update!(:free, &Enum.reverse/1)
  end

  defp expand_data([], state), do: state

  defp expand_data([block_size | next_blocks], state) do
    block_size_int = String.to_integer(block_size)

    state.index..(state.index + block_size_int - 1)//1
    |> Enum.reduce(state, fn idx, acc ->
      acc
      |> Map.update!(:blocks, &Map.put(&1, idx, if(state.type == :file, do: state.id, else: :free)))
      |> Map.update!(state.type, &[idx | &1])
    end)
    |> Map.update!(:index, &(&1 + block_size_int))
    |> Map.update!(:id, &if(state.type == :file, do: &1 + 1, else: &1))
    |> Map.update!(:type, fn
      :file -> :free
      :free -> :file
    end)
    |> then(&expand_data(next_blocks, &1))
  end

  defp compact_data(%{free: [free | _], file: [file | _]} = state) when file < free do
    state.blocks
  end

  defp compact_data(state) do
    {to_move, remaining_file} = List.pop_at(state.file, 0)
    {destination, remaining_free} = List.pop_at(state.free, 0)

    state
    |> Map.update!(:blocks, fn blocks ->
      blocks
      |> Map.put(to_move, :free)
      |> Map.put(destination, blocks[to_move])
    end)
    |> Map.put(:file, remaining_file)
    |> Map.put(:free, remaining_free)
    |> compact_data()
  end

  defp calculate_checksum(blocks) do
    blocks
    |> Enum.map(fn
      {_idx, :free} -> 0
      {idx, id} -> idx * id
    end)
    |> Enum.sum()
  end
end
