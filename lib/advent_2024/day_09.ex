defmodule Advent2024.Day09 do
  @moduledoc false

  @input Advent2024.get_input_for_day(9)

  def part_1(input \\ @input) do
    input
    |> parse_input()
    |> compress(:part_1)
    |> calculate_checksum()
  end

  def part_2(input \\ @input) do
    input
    |> parse_input()
    |> Map.fetch!(:blocks)
    |> compress(:part_2)
    |> calculate_checksum()
  end

  defp compress(%{part_1_buffer: %{free: [free | _], file: [file | _]}} = state, :part_1)
       when file < free,
       do: state.blocks

  defp compress(state, :part_1) do
    {to_move, remaining_file} = List.pop_at(state.part_1_buffer.file, 0)
    {destination, remaining_free} = List.pop_at(state.part_1_buffer.free, 0)

    state
    |> Map.update!(:blocks, fn blocks ->
      blocks
      |> Map.put(to_move, :free)
      |> Map.put(destination, blocks[to_move])
    end)
    |> Map.update!(:part_1_buffer, &Map.put(&1, :file, remaining_file))
    |> Map.update!(:part_1_buffer, &Map.put(&1, :free, remaining_free))
    |> compress(:part_1)
  end

  defp compress(blocks, :part_2) do
    files = scan_for_files(blocks)

    Enum.reduce(files, blocks, fn {id, length, index} = file, acc ->
      case first_free_space(acc, length) do
        nil ->
          acc

        destination_index when destination_index < index ->
          acc
          |> delete_file(file)
          |> write_file({id, length, destination_index})

        _otherwise ->
          acc
      end
    end)
  end

  def scan_for_files(blocks) do
    scan_for_files(blocks, 0, nil, [])
  end

  defp scan_for_files(blocks, index, nil, seen) do
    case blocks[index] do
      :free -> scan_for_files(blocks, index + 1, nil, seen)
      nil -> seen
      id -> scan_for_files(blocks, index + 1, {id, 1, index}, seen)
    end
  end

  defp scan_for_files(blocks, check_index, {id, length, file_index} = file, seen) do
    case blocks[check_index] do
      :free -> scan_for_files(blocks, check_index + 1, nil, [file | seen])
      nil -> [file | seen]
      ^id -> scan_for_files(blocks, check_index + 1, {id, length + 1, file_index}, seen)
      other_id -> scan_for_files(blocks, check_index + 1, {other_id, 1, check_index}, [file | seen])
    end
  end

  def first_free_space(blocks, length_needed) do
    index = 0

    case blocks[index] do
      :free -> first_free_space(blocks, length_needed, index, index + 1)
      _id -> first_free_space(blocks, length_needed, nil, index + 1)
    end
  end

  defp first_free_space(blocks, _length_needed, _free_start_index, check_index)
       when check_index == map_size(blocks),
       do: nil

  defp first_free_space(_blocks, length_needed, free_start_index, check_index)
       when is_integer(free_start_index) and check_index - free_start_index == length_needed,
       do: free_start_index

  defp first_free_space(blocks, length_needed, nil, check_index) do
    case blocks[check_index] do
      :free -> first_free_space(blocks, length_needed, check_index, check_index + 1)
      _id -> first_free_space(blocks, length_needed, nil, check_index + 1)
    end
  end

  defp first_free_space(blocks, length_needed, free_start_index, check_index) do
    case blocks[check_index] do
      :free -> first_free_space(blocks, length_needed, free_start_index, check_index + 1)
      _id -> first_free_space(blocks, length_needed, nil, check_index + 1)
    end
  end

  defp delete_file(blocks, file) do
    {_id, length, index} = file

    Enum.reduce(index..(index + length - 1), blocks, &Map.put(&2, &1, :free))
  end

  defp write_file(blocks, file) do
    {id, length, index} = file

    Enum.reduce(index..(index + length - 1), blocks, &Map.put(&2, &1, id))
  end

  defp calculate_checksum(blocks) do
    blocks
    |> Enum.map(fn
      {_idx, :free} -> 0
      {idx, id} -> idx * id
    end)
    |> Enum.sum()
  end

  defp parse_input(txt) do
    state = %{type: :file, index: 0, id: 0, blocks: %{}, part_1_buffer: %{free: [], file: []}}

    chars =
      txt
      |> String.trim()
      |> String.graphemes()

    chars
    |> expand_data(state)
    |> Map.update!(:part_1_buffer, fn buffer -> Map.update!(buffer, :free, &Enum.reverse/1) end)
    |> Map.put(
      :chunks,
      Enum.map(Enum.with_index(chars), fn {char, idx} ->
        if rem(idx, 2) == 0,
          do: {String.to_integer(char), :file},
          else: {String.to_integer(char), :free}
      end)
    )
  end

  defp expand_data([], state), do: state

  defp expand_data([block_size | next_blocks], state) do
    block_size_int = String.to_integer(block_size)

    state.index..(state.index + block_size_int - 1)//1
    |> Enum.reduce(state, fn idx, acc ->
      acc
      |> Map.update!(:blocks, &Map.put(&1, idx, if(state.type == :file, do: state.id, else: :free)))
      |> Map.update!(:part_1_buffer, fn buffer -> Map.update!(buffer, state.type, &[idx | &1]) end)
    end)
    |> Map.update!(:index, &(&1 + block_size_int))
    |> Map.update!(:id, &if(state.type == :file, do: &1 + 1, else: &1))
    |> Map.update!(:type, fn
      :file -> :free
      :free -> :file
    end)
    |> then(&expand_data(next_blocks, &1))
  end
end
