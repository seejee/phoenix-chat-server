defmodule ElixirChat.ChatLogServer do
  use ExActor.GenServer, export: :chat_log_server
  alias ElixirChat.ChatLog, as: Chats
  alias ElixirChat.TeacherRosterServer, as: Teachers
  alias ElixirChat.StudentRosterServer, as: Students

  defstart start_link do
    Chats.new |> initial_state
  end

  defcall stats, state: chats do
    chats |> Chats.stats |> reply
  end

  defcall create_chat_for_next_student(teacher_id), state: chats do
    student_id = Students.assign_next_student_to(teacher_id)

    if student_id do
      :ok = Teachers.claim_student(teacher_id, student_id)
      {chats, chat} = Chats.new_chat(chats, teacher_id, student_id)
      set_and_reply(chats, chat)
    else
      set_and_reply(chats, nil)
    end
  end

  defcall teacher_entered(chat_id, teacher_id), state: chats do
    {chats, chat} = Chats.teacher_entered(chats, chat_id, teacher_id)
    set_and_reply(chats, chat)
  end

  defcall student_entered(chat_id, student_id), state: chats do
    {chats, chat} = Chats.student_entered(chats, chat_id, student_id)
    set_and_reply(chats, chat)
  end

  defcast append_message(chat_id, role, message), state: chats do
    chats |> Chats.append_message(chat_id, role, message) |> new_state
  end

  defcall terminate(chat_id), state: chats do
    {chats, chat} = Chats.terminate(chats, chat_id)

    student_id = chat.student_id
    teacher_id = chat.teacher_id

    :ok = Teachers.chat_finished(teacher_id, student_id)
    :ok = Students.chat_finished(student_id)

    set_and_reply(chats, chat)
  end
end
