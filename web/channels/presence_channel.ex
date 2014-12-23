defmodule ElixirChat.PresenceChannel do
  use Phoenix.Channel
  alias ElixirChat.StudentRosterServer, as: Students

  def join(socket, "global", %{"userId" => id, "role" => "teacher"}) do
    IO.puts "teacher"
    broadcast_status socket
    {:ok, socket}
  end

  def join(socket, "global", %{"userId" => id, "role" => "student"}) do
    IO.puts "student"
    broadcast_status socket
    {:ok, socket}
  end

  def broadcast_status(socket) do
    data = %{
      teachers: %{
        total:    0
      },
      students: Students.stats
    }

    broadcast socket, "user:status", data
  end
end
