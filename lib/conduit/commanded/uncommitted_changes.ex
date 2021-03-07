defmodule Conduit.Commanded.UncommittedChanges do
  defstruct [:events]

  def new do
    %__MODULE__{events: []}
  end

  def append_events(changes, []) do
    changes
  end

  def append_events(changes, events) do
    Map.put(changes, :events, changes.events ++ events)
  end

  def append_event(changes, event) do
    Map.put(changes, :events, changes.events ++ [event])
  end

  def get_events(changes) do
    changes.events
  end
end
