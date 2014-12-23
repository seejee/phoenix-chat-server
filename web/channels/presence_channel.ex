defmodule ElixirChat.PresenceChannel do
  use Phoenix.Channel
  alias ElixirChat.TeacherRosterServer, as: Teachers
  alias ElixirChat.StudentRosterServer, as: Students

  def join(socket, "global", %{"userId" => id, "role" => "teacher"}) do
    Teachers.add %{
      id: id,
      student_ids: []
    }

    broadcast_status socket

    {:ok, socket}
  end

  def join(socket, "global", %{"userId" => id, "role" => "student"}) do
    Students.add %{
      id: id,
      teacher_id: nil
    }

    broadcast_status socket

    {:ok, socket}
  end

  def broadcast_status(socket) do
    data = %{
      teachers: Teachers.stats,
      students: Students.stats
    }

    broadcast socket, "user:status", data
  end
end
