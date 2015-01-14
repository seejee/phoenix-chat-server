defmodule Actor do
  def start do
    spawn fn -> loop(initial_state) end
  end

  def add(pid, amount) do
    send pid, {:add, amount}
    pid
  end

  def subtract(pid, amount) do
    send pid, {:subtract, amount}
    pid
  end

  def print(pid) do
    send pid, {:print}
    pid
  end

  def initial_state do
    0
  end

  def loop(state) do
    new_state = receive do
      {:add,      amount} -> state + amount
      {:subtract, amount} -> state - amount
      {:print           } -> IO.puts(state); state
    end

    loop(new_state)
  end
end
