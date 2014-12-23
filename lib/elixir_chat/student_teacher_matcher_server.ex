defmodule ElixirChat.StudentTeacherMatcherServer do
  use GenServer
  alias ElixirChat.TeacherRosterServer, as: Teachers
  alias ElixirChat.StudentRosterServer, as: Students

  def start_link do
    GenServer.start_link(__MODULE__, nil, name: :student_teacher_matcher_server)
  end

  def assign_next_student_to(teacher_id) do
    GenServer.call(:student_teacher_matcher_server, {:assign_next_student_to, teacher_id})
  end

  def init(_) do
    {:ok, {}}
  end

  def handle_call({:assign_next_student_to, teacher_id}, _from, state) do
    student_id = Students.assign_next_student_to(teacher_id)

    if student_id do
      #Teachers.claim_student(student_id)
      {:reply, student_id, state}
    else
      {:reply, nil, state}
    end
  end
end
