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

  def assign_teacher_to_student(roster, teacher_id, student_id) do
    index  = Enum.find_index(roster, fn(s) -> s.id == student_id end)
    List.update_at(roster, index, fn(s) -> set_teacher_on_student(s, teacher_id) end)
  end

  def set_teacher_on_student(student, teacher_id) do
    Map.merge(student, %{status: "chatting", teacher_id: teacher_id})
  end

  def exists?(roster, student_id) do
    Enum.any?(roster, fn(s) -> s.id == student_id end)
  end

  def stats(roster) do
    %{
      total:    length(roster),
      waiting:  waiting(roster),
      chatting: chatting(roster),
      finished: 0,
    }
  end

  def next_waiting(roster) do
    index = Enum.find_index(roster, fn(s) -> s.status == "waiting" end)

    if index do
      Enum.at(roster, index)
    end
  end

  def waiting(roster) do
    Enum.count(roster, fn(s) -> s.status == "waiting" end)
  end

  def chatting(roster) do
    Enum.count(roster, fn(s) -> s.status == "chatting" end)
  end
end
