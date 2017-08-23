defmodule Calculator do
  def start do
    spawn(fn -> loop(0) end)
  end

  defp loop(current_val) do
    new_val = receive do
      {:value, client_id} -> send(client_id, {:response, current_val})
        current_val
      {:add, value} -> current_val + value
      {:sub, value} -> current_val - value
      {:mult, value} -> current_val * value
      {:div, value} -> current_val / value

      invalid_request -> IO.puts("Invalid Request #{{inspect invalid_request}}")
        current_val
    end
    loop(new_val)
  end

  def value(server_id) do
    send(server_id, {:value, self()})
    receive do
      {:response, value} -> value
    end
  end

  def add(server_id, value) do
    send(server_id, {:add, value})
    value(server_id)
  end

  def sub(server_id, value) do
    send(server_id, {:sub, value})
    value(server_id)
  end

  def mult(server_id, value) do
    send(server_id, {:mult, value})
    value(server_id)
  end

  def div(server_id, value) do
    send(server_id, {:div, value})
    value(server_id)
  end
end
