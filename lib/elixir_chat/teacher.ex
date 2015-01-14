defmodule ElixirChat.Teacher do
  defstruct id: -1, student_ids: []

  def can_accept_more_students?(teacher) do
    if teacher do
      length(teacher.student_ids) < 5
    else
      false
    end
  end
end
