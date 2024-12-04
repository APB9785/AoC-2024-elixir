defmodule Advent2024 do
  @moduledoc """
  Helper functions
  """

  def get_input_for_day(day) do
    path = Application.app_dir(:advent_2024, "priv/day_#{day}_input.txt")
    File.read!(path)
  end
end
