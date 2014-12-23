defmodule ElixirChat.TeacherRoster do
  def new do
    []
  end

  def add(roster, teacher) do
    teacher = Map.merge(teacher, %{student_ids: []})

    unless exists?(roster, teacher) do
      roster = roster ++ [teacher]
    end

    roster
  end

  def remove(roster, teacher) do
    roster -- [teacher]
  end

  def claim_student(roster, teacher_id, student_id) do
    index  = Enum.find_index(roster, fn(t) -> t.id == teacher_id end)
    List.update_at(roster, index, fn(t) -> set_student_on_teacher(t, student_id) end)
  end

  def set_student_on_teacher(teacher, student_id) do
    Map.merge(teacher, %{student_ids: teacher.student_ids ++ [student_id]})
  end

  def chat_finished(roster, teacher_id, student_id) do
    index  = Enum.find_index(roster, fn(t) -> t.id == teacher_id end)
    List.update_at(roster, index, fn(t) -> remove_student(t, student_id) end)
  end

  def remove_student(teacher, student_id) do
    Map.merge(teacher, %{student_ids: teacher.student_ids -- [student_id]})
  end

  def exists?(roster, teacher) do
    Enum.any?(roster, fn(t) -> t.id == teacher.id end)
  end

  def find(roster, teacher_id) do
    Enum.find(roster, fn(t) -> t.id == teacher_id end)
  end

  def can_accept_more_students?(roster, teacher) do
    if teacher do
      length(teacher.student_ids) < 5
    else
      false
    end
  end

  def stats(roster) do
    %{
      total: length(roster),
    }
  end
end

