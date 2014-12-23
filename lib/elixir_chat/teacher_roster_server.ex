defmodule ElixirChat.TeacherRosterServer do
  use GenServer
  alias ElixirChat.TeacherRoster, as: Roster

  def start_link do
    GenServer.start_link(__MODULE__, nil, name: :teacher_roster_server)
  end

  def add(teacher) do
    GenServer.call(:teacher_roster_server, {:add, teacher})
  end

  def stats do
    GenServer.call(:teacher_roster_server, :stats)
  end

  def init(_) do
    {:ok, Roster.new}
  end

  #  def handle_cast({:add, teacher}, roster) do
  #    #roster = Roster.add(roster, teacher)
  #    {:noreply, roster}
  #  end

  def handle_call({:add, teacher}, _from, roster) do
    roster = Roster.add(roster, teacher)
    {:reply, teacher, roster}
  end

  def handle_call(:stats, _from, roster) do
    result = Roster.stats(roster)
    {:reply, result, roster}
  end
end

