defmodule ElixirChat.PresenceChannel do
  use Phoenix.Channel
  alias ElixirChat.TeacherRosterServer, as: Teachers
  alias ElixirChat.StudentRosterServer, as: Students

  def join(socket, "global", %{"userId" => id, "role" => "teacher"}) do
    socket = assign(socket, :id, id)

    Teachers.add %{
      id: id,
      student_ids: []
    }

    broadcast_status socket

    {:ok, socket}
  end

  def join(socket, "global", %{"userId" => id, "role" => "student"}) do
    socket = assign(socket, :id, id)

    Students.add %{
      id:         id,
      status:     "waiting",
      teacher_id: nil
    }

    broadcast_status socket

    {:ok, socket}
  end

  def leave(socket, "global") do
    IO.puts "leaving"

    student_id = socket.assigns[:id]
    Students.remove student_id

    broadcast_status socket

    socket
  end

  def broadcast_status(socket) do
    data = %{
      teachers: Teachers.stats,
      students: Students.stats
    }

    broadcast socket, "user:status", data
  end
end
