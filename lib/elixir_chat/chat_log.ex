defmodule ElixirChat.ChatLog do
  alias ElixirChat.Chat

  def new do
    HashDict.new
  end

  def new_chat(chats, teacher_id, student_id) do
    id = UUID.uuid4()

    chat = %Chat{
      id: id,
      teacher_id: teacher_id,
      student_id: student_id,
    }

    {Dict.put(chats, id, chat), chat}
  end

  def terminate(chats, chat_id) do
    chats = Dict.update!(chats, chat_id, fn(c) ->
      Map.merge(c, %{status: "finished"})
    end)

    {chats, chats[chat_id]}
  end

  def teacher_entered(chats, chat_id, teacher_id) do
    chats = Dict.update!(chats, chat_id, fn(c) ->
      Map.merge(c, %{teacher_entered: true})
    end)

    {chats, chats[chat_id]}
  end

  def student_entered(chats, chat_id, student_id) do
    chats = Dict.update!(chats, chat_id, fn(c) ->
      Map.merge(c, %{student_entered: true})
    end)

    {chats, chats[chat_id]}
  end

  def append_message(chats, chat_id, role, message) do
    chats = Dict.update!(chats, chat_id, fn(c) ->
      message  = %{
        message: message,
        role:    role
      }
      messages = c.messages ++ [message]
      Map.merge(c, %{messages: messages})
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
    Enum.filter(chats, fn(c) -> c.status == "active" end)
  end
end
