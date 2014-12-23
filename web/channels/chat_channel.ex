defmodule ElixirChat.ChatChannel do
  use Phoenix.Channel
  alias ElixirChat.ChatLogServer, as: Chats

  def join(socket, chat_id, %{"userId" => id, "role" => "teacher"}) do
    socket = assign(socket, :teacher_id, id)
    socket = assign(socket, :chat_id, chat_id)

    {:ok, socket}
  end

  def join(socket, chat_id, %{"userId" => id, "role" => "student"}) do
    socket = assign(socket, :student_id, id)
    socket = assign(socket, :chat_id, chat_id)

    {:ok, socket}
  end

  def leave(socket, _chat_id) do
    socket
  end

  def event(socket, "teacher:joined", message) do
    id      = socket.assigns[:teacher_id]
    chat_id = socket.assigns[:chat_id]

    chat = Chats.teacher_entered(chat_id, id)

    if chat.teacher_entered && chat.student_entered do
      broadcast socket, "chat:ready", %{}
    end

    socket
  end

  def event(socket, "student:joined", message) do
    id      = socket.assigns[:student_id]
    chat_id = socket.assigns[:chat_id]

    chat = Chats.student_entered(chat_id, id)

    if chat.teacher_entered && chat.student_entered do
      broadcast socket, "chat:ready", %{}
    end

    socket
  end

  def event(socket, "student:send", payload) do
    chat_id = socket.assigns[:chat_id]

    Chats.append_message chat_id, "student", payload["message"]
    broadcast socket, "teacher:receive", payload
    socket
  end

  def event(socket, "teacher:send", payload) do
    chat_id = socket.assigns[:chat_id]

    Chats.append_message chat_id, "teacher", payload["message"]
    broadcast socket, "student:receive", payload
    socket
  end
end
