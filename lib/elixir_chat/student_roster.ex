defmodule ElixirChat.StudentRoster do
  def new do
    []
  end

  def add(roster, student) do
    student = Map.merge(student, %{
      status:     "waiting",
      teacher_id: nil
    })

    unless exists?(roster, student.id) do
      roster = roster ++ [student]
    end

    roster
  end

  def remove(roster, student_id) do
    Enum.reject(roster, fn(s) -> s.id == student_id end)
  end

  def exists?(roster, student_id) do
    Enum.any?(roster, fn(s) -> s.id == student_id end)
  end

  def stats(roster) do
    %{
      total:    length(roster),
      waiting:  waiting(roster),
      chatting: 0,
      finished: 0,
    }
  end

  def waiting(roster) do
    Enum.count(roster, fn(s) -> s.status == "waiting" end)
  end

  def claim_next(roster) do
    [student | tail] = roster
    {student, tail}
  end
end
