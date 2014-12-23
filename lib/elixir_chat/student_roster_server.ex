defmodule ElixirChat.StudentRosterServer do
  use GenServer
  alias ElixirChat.StudentRoster, as: Roster

  def start_link do
    GenServer.start_link(__MODULE__, nil, name: :student_roster_server)
  end

  def stats do
    GenServer.call(:student_roster_server, :stats)
  end

  def init(_) do
    {:ok, Roster.new}
  end

  def handle_cast({:add, student}, roster) do
    #roster = Roster.add(roster, student)
    {:noreply, roster}
  end

  def handle_call(:stats, _from, roster) do
    result = Roster.stats(roster)
    {:reply, result, roster}
  end
end
