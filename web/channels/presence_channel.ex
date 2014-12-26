defmodule ElixirChat.PresenceChannel do
  use Phoenix.Channel
  alias ElixirChat.ChatLogServer, as: Chats
  alias ElixirChat.TeacherRosterServer, as: Teachers
  alias ElixirChat.StudentRosterServer, as: Students

  def join(socket, "teachers", %{"userId" => id, "role" => "teacher"}) do
    Teachers.add %{id: id}
    socket = assign(socket, :id, id)
    {:ok, socket}
  end

  def join(socket, "students", %{"userId" => id, "role" => "student"}) do
    # not registering student here because it causes races
    {:ok, socket}
  end

  def event(socket, "student:ready", %{"userId" => id}) do
    Students.add %{id: id}
    socket = assign(socket, :id, id)
    broadcast_status
    socket
  end

  def leave(socket, _message) do
    Students.remove(socket.assigns[:id])
    broadcast_status
    socket
  end

  def event(socket, "claim:student", %{"teacherId" => teacher_id}) do
    if Teachers.can_accept_more_students?(teacher_id) do
      chat = Chats.create_chat_for_next_student(teacher_id)

      if chat do
        reply socket, "new:chat:#{chat.teacher_id}", chat
        Phoenix.Channel.broadcast "presence", "students", "new:chat:#{chat.student_id}", chat
        broadcast_status
      end
    end

    socket
  end

  def broadcast_status do
    data = %{
      teachers: Teachers.stats,
      students: Students.stats
    }

    Phoenix.Channel.broadcast "presence", "teachers", "user:status", data
  end
end
