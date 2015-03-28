defmodule ElixirChat.ChatLog do
  alias ElixirChat.Chat

  def new do
    HashDict.new
  end

  def new_chat(chats, teacher_id, student_id) do
    chat = Chat.new(teacher_id, student_id)
    {Dict.put(chats, chat.id, chat), chat}
  end

  def terminate(chats, chat_id) do
    chats = Dict.update!(chats, chat_id, &Chat.terminate/1)
    {chats, chats[chat_id]}
  end

  def teacher_entered(chats, chat_id, teacher_id) do
    chats = Dict.update!(chats, chat_id, &Chat.teacher_entered/1)
    {chats, chats[chat_id]}
  end

  def student_entered(chats, chat_id, student_id) do
    chats = Dict.update!(chats, chat_id, &Chat.student_entered/1)
    {chats, chats[chat_id]}
  end

  def append_message(chats, chat_id, role, message) do
    chats = Dict.update!(chats, chat_id, fn(c) ->
      Chat.append_message(c, role, message)
    end)

    chats
  end

  def stats(chats) do
    chats = Dict.values(chats)

    %{
      total: length(chats),
      active: active(chats)
    }
  end

  def active(chats) do
    Enum.filter(chats, &Chat.active?/1)
  end
end
