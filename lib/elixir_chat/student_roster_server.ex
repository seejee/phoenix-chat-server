defmodule ElixirChat.StudentRosterServer do
  use GenServer
  alias ElixirChat.StudentRoster, as: Roster

  def start_link do
    GenServer.start_link(__MODULE__, nil, name: :student_roster_server)
  end

  def add(student) do
    GenServer.call(:student_roster_server, {:add, student})
  end

  def remove(student_id) do
    GenServer.call(:student_roster_server, {:remove, student_id})
  end

  def assign_next_student_to(teacher_id) do
    GenServer.call(:student_roster_server, {:assign_next_student_to, teacher_id})
  end

  def stats do
    GenServer.call(:student_roster_server, :stats)
  end

  def init(_) do
    {:ok, Roster.new}
  end

  #  def handle_cast({:add, student}, roster) do
  #    #roster = Roster.add(roster, student)
  #    {:noreply, roster}
  #  end

  def handle_call({:add, student}, _from, roster) do
    roster = Roster.add(roster, student)
    {:reply, student, roster}
  end

  def handle_call({:remove, student_id}, _from, roster) do
    roster = Roster.remove(roster, student_id)
    {:reply, student_id, roster}
  end

  def handle_call({:assign_next_student_to, teacher_id}, _from, roster) do
    next_student = Roster.next_waiting(roster)

    if next_student do
      student_id = next_student.id
      roster     = Roster.assign_teacher_to_student(roster, teacher_id, student_id)
      {:reply, student_id, roster}
    else
      {:reply, nil, roster}
    end
  end

  def handle_call(:stats, _from, roster) do
    result = Roster.stats(roster)
    {:reply, result, roster}
  end
end
