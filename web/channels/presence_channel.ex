defmodule ElixirChat.PresenceChannel do
  use Phoenix.Channel
  alias ElixirChat.ChatLogServer, as: Chats
  alias ElixirChat.TeacherRosterServer, as: Teachers
  alias ElixirChat.StudentRosterServer, as: Students

  def join(socket, "global", %{"userId" => id, "role" => "teacher"}) do
    Teachers.add %{id: id}
    socket = assign(socket, :id, id)

    broadcast_status socket

    {:ok, socket}
  end

  def join(socket, "global", %{"userId" => id, "role" => "student"}) do
    Students.add %{id: id}
    socket = assign(socket, :id, id)

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

  def event(socket, "claim:student", %{"teacherId" => teacher_id}) do
    if Teachers.can_accept_more_students?(teacher_id) do
      chat = Chats.create_chat_for_next_student(teacher_id)

      if chat do
        IO.puts "claiming student"
        IO.puts(inspect(chat))

        broadcast socket, "new:chat:student:#{chat.student_id}", chat
        broadcast socket, "new:chat:teacher:#{chat.teacher_id}", chat
        broadcast_status socket
      end
    end

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
