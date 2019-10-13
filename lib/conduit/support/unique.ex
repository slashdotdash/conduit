defmodule Conduit.Support.Unique do
  use GenServer

  def start_link(_arg) do
    GenServer.start_link(__MODULE__, %{}, name: __MODULE__)
  end

  def claim(context, owner, value) do
    GenServer.call(__MODULE__, {:claim, context, owner, value})
  end

  def init(state), do: {:ok, state}

  def handle_call({:claim, context, owner, value}, _from, assignments) do
    {reply, state} =
      case Map.get(assignments, context) do
        nil ->
          values = Map.new([{value, owner}])
          {:ok, Map.put(assignments, context, values)}

        values ->
          case Map.get(values, value) do
            ^owner ->
              {:ok, assignments}

            nil ->
              values = Map.put(values, value, owner)
              {:ok, Map.put(assignments, context, values)}

            _ ->
              {{:error, :already_taken}, assignments}
          end
      end

    {:reply, reply, state}
  end
end
