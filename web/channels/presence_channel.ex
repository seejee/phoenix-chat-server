defmodule ElixirChat.PresenceChannel do
  use Phoenix.Channel

  alias ElixirChat.Teacher
  alias ElixirChat.Student

  alias ElixirChat.ChatLifetimeServer, as: Chats
  alias ElixirChat.TeacherRosterServer, as: Teachers
  alias ElixirChat.StudentRosterServer, as: Students

  def join("presence:teachers", %{"userId" => id, "role" => "teacher"}, socket) do
    Teachers.add %Teacher{id: id}
    socket = assign(socket, :id, id)
    {:ok, socket}
  end

  def join("presence:students", %{"userId" => id, "role" => "student"}, socket) do
    # not broadcasting status student here because it causes races
    {:ok, socket}
  end

  def leave(_message, socket) do
    Students.remove(socket.assigns[:id])
    broadcast_status
    {:ok, socket}
  end

  def handle_in("student:ready", %{"userId" => id}, socket) do
    Students.add %Student{id: id}
    socket = assign(socket, :id, id)
    broadcast_status
    {:ok, socket}
  end

  def handle_in("claim:student", %{"teacherId" => teacher_id}, socket) do
    chat = Chats.create_chat_for_next_student(teacher_id)

    if chat do
      reply socket, "new:chat:#{chat.teacher_id}", chat
      Phoenix.Channel.broadcast "presence:students", "new:chat", chat
    end

    {:ok, socket}
  end

  def broadcast_status do
    data = %{
      teachers: Teachers.stats,
      students: Students.stats
    }

    broadcast "presence:teachers", "user:status", data
  end
end
