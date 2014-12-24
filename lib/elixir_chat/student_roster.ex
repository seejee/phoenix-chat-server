defmodule ElixirChat.StudentRoster do
  def new do
    HashDict.new
  end

  def add(roster, student) do
    student = Map.merge(student, %{
      status:     "waiting",
      teacher_id: nil
    })

    Dict.put(roster, student.id, student)
  end

  def remove(roster, student_id) do
    Dict.delete(roster, student_id)
  end

  def assign_teacher_to_student(roster, teacher_id, student_id) do
    Dict.update!(roster, student_id, fn(s) -> set_teacher_on_student(s, teacher_id) end)
  end

  def chat_finished(roster, student_id) do
    Dict.update!(roster, student_id, fn(s) -> set_finished(s) end)
  end

  def stats(roster) do
    students = students(roster)

    %{
      total:    length(students),
      waiting:  waiting(students),
      chatting: chatting(students),
      finished: finished(students),
    }
  end

  def next_waiting(roster) do
    Enum.find(students(roster), fn(s) -> s.status == "waiting" end)
  end

  def students(roster) do
    Dict.values(roster)
  end

  def set_teacher_on_student(student, teacher_id) do
    Map.merge(student, %{status: "chatting", teacher_id: teacher_id})
  end

  def set_finished(student) do
    Map.merge(student, %{status: "finished", teacher_id: nil})
  end

  def waiting(students) do
    Enum.count(students, fn(s) -> s.status == "waiting" end)
  end

  def chatting(students) do
    Enum.count(students, fn(s) -> s.status == "chatting" end)
  end

  def finished(students) do
    Enum.count(students, fn(s) -> s.status == "finished" end)
  end
end
