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
      }
    }

  {Dict.put(chats, id, chat), chat}
  end
end
