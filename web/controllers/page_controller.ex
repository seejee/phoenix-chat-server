defmodule ElixirChat.PageController do
  use ElixirChat.Web, :controller

  def index(conn, _params) do
    data = %{
      teachers: ElixirChat.TeacherRosterServer.stats_extended,
      students: ElixirChat.StudentRosterServer.stats_extended,
      chats:    ElixirChat.ChatLogServer.stats
    }

    json conn, data
  end
end
