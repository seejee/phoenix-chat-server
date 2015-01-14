defmodule ElixirChat.Chat do
  defstruct id: nil,
    status: "active",
    teacher_id: nil,
    student_id: nil,
    teacher_entered: false,
    student_entered: false,
    messages: []
end

