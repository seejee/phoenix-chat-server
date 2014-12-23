defmodule ElixirChat.TeacherRoster do
  def new do
    []
  end

  def add(roster, teacher) do
    unless exists?(roster, teacher) do
      roster = roster ++ [teacher]
    end

    roster
  end

  def remove(roster, teacher) do
    roster -- [teacher]
  end

  def exists?(roster, teacher) do
    Enum.member?(roster, teacher)
  end

  def stats(roster) do
    %{
      total: length(roster),
    }
  end
end

