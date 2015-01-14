defmodule ElixirChat.TeacherRoster do
  alias ElixirChat.Teacher, as: Teacher

  def new do
    HashDict.new
  end

  def add(roster, teacher = %Teacher{}) do
    Dict.put(roster, teacher.id, teacher)
  end

  def remove(roster, teacher_id) do
    Dict.delete(roster, teacher_id)
  end

  def claim_student(roster, teacher_id, student_id) do
    Dict.update!(roster, teacher_id, fn(t) ->
      %{t | student_ids: t.student_ids ++ [student_id]}
    end)
  end

  def chat_finished(roster, teacher_id, student_id) do
    Dict.update!(roster, teacher_id, fn(t) -> remove_student(t, student_id) end)
  end

  defp remove_student(teacher = %Teacher{}, student_id) do
    %{teacher | student_ids: teacher.student_ids -- [student_id]}
  end

  def find(roster, teacher_id) do
    roster[teacher_id]
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
