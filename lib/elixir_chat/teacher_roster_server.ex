defmodule ElixirChat.TeacherRosterServer do
  use ExActor.GenServer, export: :teacher_roster_server
  alias ElixirChat.TeacherRoster, as: Roster

  defstart start_link do
    Roster.new |> initial_state
  end

  defcall stats, state: roster do
    roster |> Roster.stats |> reply
  end

  defcall stats_extended, state: roster do
    roster |> Roster.stats_extended |> reply
  end

  defcall add(teacher), state: roster do
    roster |> Roster.add(teacher) |> set_and_reply(teacher)
  end

  defcall claim_student(teacher_id, student_id), state: roster  do
    roster |> Roster.claim_student(teacher_id, student_id) |> set_and_reply(teacher_id)
  end

  defcall can_accept_more_students?(teacher_id), state: roster  do
    teacher = Roster.find(roster, teacher_id)
    roster |> Roster.can_accept_more_students?(teacher) |> reply
  end

  defcall chat_finished(teacher_id, student_id), state: roster  do
    roster |> Roster.chat_finished(teacher_id, student_id) |> set_and_reply(:ok)
  end
end
