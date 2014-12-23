defmodule ElixirChat.ChatLogServer do
  use GenServer
  alias ElixirChat.ChatLog, as: Chats
  alias ElixirChat.TeacherRosterServer, as: Teachers
  alias ElixirChat.StudentRosterServer, as: Students

  def start_link do
    GenServer.start_link(__MODULE__, nil, name: :chat_log_server)
  end

  def create_chat_for_next_student(teacher_id) do
    GenServer.call(:chat_log_server, {:create_chat_for_next_student, teacher_id})
  end

  def teacher_entered(chat_id, teacher_id) do
    GenServer.call(:chat_log_server, {:teacher_entered, chat_id, teacher_id})
  end

  def student_entered(chat_id, student_id) do
    GenServer.call(:chat_log_server, {:student_entered, chat_id, student_id})
  end

  def append_message(chat_id, role, message) do
    GenServer.cast(:chat_log_server, {:append_message, chat_id, role, message})
  end

  def init(_) do
    {:ok, Chats.new}
  end

  def handle_call({:teacher_entered, chat_id, teacher_id}, _from, chats) do
    {chats, chat} = Chats.teacher_entered(chats, chat_id, teacher_id)
    {:reply, chat, chats}
  end

  def handle_call({:student_entered, chat_id, student_id}, _from, chats) do
    {chats, chat} = Chats.student_entered(chats, chat_id, student_id)
    {:reply, chat, chats}
  end

  def handle_cast({:append_message, chat_id, role, message}, chats) do
    chats = Chats.append_message(chats, chat_id, role, message)
    {:noreply, chats}
  end

  def handle_call({:create_chat_for_next_student, teacher_id}, _from, chats) do
    student_id = Students.assign_next_student_to(teacher_id)

    if student_id do
      Teachers.claim_student(teacher_id, student_id)
      {chats, chat} = Chats.new_chat(chats, teacher_id, student_id)
      {:reply, chat, chats}
    else
      {:reply, nil, chats}
    end
  end
end
