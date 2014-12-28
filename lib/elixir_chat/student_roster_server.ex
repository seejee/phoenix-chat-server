defmodule ElixirChat.StudentRosterServer do
  use ExActor.GenServer, export: :student_roster_server
  alias ElixirChat.StudentRoster, as: Roster

  defstart start_link do
    Roster.new |> initial_state
  end

  defcall stats, state: roster do
    roster |> Roster.stats |> reply
  end

  defcall stats_extended, state: roster do
    roster |> Roster.stats_extended |> reply
  end

  defcall add(student), state: roster do
    roster |> Roster.add(student) |> set_and_reply(student)
  end

  defcall remove(student_id), state: roster do
    roster |> Roster.remove(student_id) |> set_and_reply(student_id)
  end

  defcall assign_next_student_to(teacher_id), state: roster do
    next_student = roster |> Roster.next_waiting

    if next_student do
      student_id = next_student.id
      roster     = Roster.assign_teacher_to_student(roster, teacher_id, student_id)
      set_and_reply(roster, student_id)
    else
      reply(nil)
    end
  end

  defcall chat_finished(student_id), state: roster do
    roster |> Roster.chat_finished(student_id) |> set_and_reply(:ok)
  end
end
