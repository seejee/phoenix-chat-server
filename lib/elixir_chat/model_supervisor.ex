defmodule ElixirChat.ModelSupervisor do
  use Supervisor

  def start_link do
    Supervisor.start_link(__MODULE__, [])
  end

  def init([]) do
    children = [
      worker(ElixirChat.ChatLifetimeServer, []),
      worker(ElixirChat.ChatLogServer, []),
      worker(ElixirChat.TeacherRosterServer, []),
      worker(ElixirChat.StudentRosterServer, []),
    ]

    supervise(children, strategy: :one_for_one)
  end
end
