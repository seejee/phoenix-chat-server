defmodule ElixirChat.ChatLifetimeServer do
  use ExActor.GenServer, export: :chat_starter_server
  alias ElixirChat.ChatLogServer, as: Chats
  alias ElixirChat.TeacherRosterServer, as: Teachers
  alias ElixirChat.StudentRosterServer, as: Students

  defstart start_link do
    nil |> initial_state
  end

  defcall create_chat_for_next_student(teacher_id), state: _ do
    student_id = Students.assign_next_student_to(teacher_id)

    if student_id do
      :ok  = Teachers.claim_student(teacher_id, student_id)
      chat = Chats.new(teacher_id, student_id)
      reply(chat)
    else
      reply(nil)
    end
  end

  defcall finish(chat_id), state: _ do
    chat = Chats.terminate(chat_id)
    :ok  = Teachers.chat_finished(chat.teacher_id, chat.student_id)
    :ok  = Students.chat_finished(chat.student_id)

    reply(chat)
  end
end
