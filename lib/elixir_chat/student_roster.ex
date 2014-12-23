defmodule ElixirChat.StudentRoster do
  def new do
    []
  end

  def add(roster, student) do
    unless exists?(roster, student) do
      roster = roster ++ [student]
    end

    roster
  end

  def remove(roster, student) do
    roster -- [student]
  end

  def exists?(roster, student) do
    Enum.member?(roster, student)
  end

  def stats(roster) do
    %{
      total:    length(roster),
      chatting: 0,
      waiting:  0,
      finished: 0,
    }
  end

  def claim_next(roster) do
    [student | tail] = roster
    {student, tail}
  end
end
