defmodule ElixirChat.ChatLogServer do
  use GenServer
  alias ElixirChat.ChatLog, as: Chats
  alias ElixirChat.TeacherRosterServer, as: Teachers
  alias ElixirChat.StudentRosterServer, as: Students

  def start_link do
    GenServer.start_link(__MODULE__, nil, name: :student_teacher_matcher_server)
  end

  def create_chat_for_next_student(teacher_id) do
    GenServer.call(:student_teacher_matcher_server, {:create_chat_for_next_student, teacher_id})
  end

  def init(_) do
    {:ok, Chats.new}
  end

  def handle_call({:create_chat_for_next_student, teacher_id}, _from, chats) do
    student_id = Students.assign_next_student_to(teacher_id)

    if student_id do
      Teachers.claim_student(teacher_id, student_id)
      chat = Chats.new_chat(chats, teacher_id, student_id)
      {:reply, chat, chats}
    else
      {:reply, nil, chats}
    end
  end
end
