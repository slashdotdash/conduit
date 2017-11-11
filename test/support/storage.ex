defmodule Conduit.Storage do
  @doc """
  Clear the event store and read store databases
  """
  def reset! do
    Application.stop(:conduit)
    Application.stop(:commanded)

    reset_eventstore()

    {:ok, _} = Application.ensure_all_started(:conduit)

    reset_readstore()
  end

  defp reset_eventstore do
    {:ok, _event_store} = Commanded.EventStore.Adapters.InMemory.start_link()
  end

  def reset_readstore do
    :ok = Ecto.Adapters.SQL.Sandbox.checkout(Conduit.Repo)

    Ecto.Adapters.SQL.Sandbox.mode(Conduit.Repo, {:shared, self()})
  end
end
