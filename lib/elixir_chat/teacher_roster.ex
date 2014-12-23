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

