defmodule ElixirChat.ChatLogServer do
  use ExActor.GenServer, export: :chat_log_server
  alias ElixirChat.ChatLog, as: Chats

  defstart start_link do
    Chats.new |> initial_state
  end

  defcall stats, state: chats do
    chats |> Chats.stats |> reply
  end

  defcall new(teacher_id, student_id), state: chats do
    {chats, chat} = Chats.new_chat(chats, teacher_id, student_id)
    set_and_reply(chats, chat)
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
    set_and_reply(chats, chat)
  end
end
