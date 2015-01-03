defmodule ElixirChat.TeacherRoster do
  def new do
    HashDict.new
  end

  def add(roster, teacher) do
    teacher = Map.merge(teacher, %{student_ids: []})

    Dict.put(roster, teacher.id, teacher)
  end

  def remove(roster, teacher) do
    Dict.delete(roster, teacher.id)
  end

  def claim_student(roster, teacher_id, student_id) do
    Dict.update!(roster, teacher_id, fn(t) ->
      %{t | student_ids: t.student_ids ++ [student_id]}
    end)
  end

  def chat_finished(roster, teacher_id, student_id) do
    Dict.update!(roster, teacher_id, fn(t) -> remove_student(t, student_id) end)
  end

  defp remove_student(teacher, student_id) do
    %{teacher | student_ids: teacher.student_ids -- [student_id]}
  end

  def find(roster, teacher_id) do
    roster[teacher_id]
  end

  def can_accept_more_students?(roster, teacher) do
    if teacher do
      length(teacher.student_ids) < 5
    else
      false
    end
  end

  def stats(roster) do
    teachers = Dict.values(roster)

    %{
      total: length(teachers),
    }
  end

  def stats_extended(roster) do
    teachers = Dict.values(roster)

    %{
      total: length(teachers),
      teachers: teachers
    }
  end
end
