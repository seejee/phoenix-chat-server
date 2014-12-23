defmodule ElixirChat.ChatLog do
  def new do
    HashDict.new
  end

  def new_chat(chats, teacher_id, student_id) do
    id = UUID.uuid1()

    chat = %{
      id: id,
      teacher_id: teacher_id,
      student_id: student_id,
      status: "active",
      teacher_events: %{
        send:      "teacher:send",
        receive:   "teacher:receive",
        terminate: "teacher:terminate",
        joined:    "teacher:joined",
      },
      student_events: %{
        send:      "student:send",
        receive:   "student:receive",
        terminate: "student:terminate",
        joined:    "student:joined",
      },
      teacher_entered: false,
      student_entered: false,
      messages: []
    }

    {Dict.put(chats, id, chat), chat}
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
end
