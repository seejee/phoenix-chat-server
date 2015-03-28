defmodule ElixirChat.Chat do
  defstruct id: nil,
    status: "active",
    teacher_id: nil,
    student_id: nil,
    teacher_entered: false,
    student_entered: false,
    messages: []

  def new(teacher_id, student_id) do
    id = UUID.uuid4()

    %ElixirChat.Chat{
      id: id,
      teacher_id: teacher_id,
      student_id: student_id,
    }
  end

  def terminate(chat) do
    Map.merge(chat, %{status: "finished"})
  end

  def teacher_entered(chat) do
    Map.merge(chat, %{teacher_entered: true})
  end

  def student_entered(chat) do
    Map.merge(chat, %{student_entered: true})
  end

  def append_message(chat, role, message) do
    message  = %{
      message: message,
      role:    role
    }
    messages = chat.messages ++ [message]
    Map.merge(chat, %{messages: messages})
  end

  def active?(chat) do
    chat.status == "active"
  end
end

