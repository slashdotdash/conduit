defmodule Conduit.AggregateCase do
  @moduledoc """
  This module defines the test case to be used by aggregate tests.
  """

  use ExUnit.CaseTemplate

  using [aggregate: aggregate] do
    quote bind_quoted: [aggregate: aggregate] do
      @aggregate_module aggregate

      import Conduit.Factory

      # assert that the expected events are returned when the given commands
      # have been executed
      defp assert_events(commands, expected_events) do
        assert execute(List.wrap(commands)) == expected_events
      end

      # execute one or more commands against the aggregate
      defp execute(commands) do
        {_, events} = Enum.reduce(commands, {%@aggregate_module{}, []}, fn (command, {aggregate, _}) ->
          events = @aggregate_module.execute(aggregate, command)

          {evolve(aggregate, events), events}
        end)

        List.wrap(events)
      end

      # apply the given events to the aggregate state
      defp evolve(aggregate, events) do
        events
        |> List.wrap()
        |> Enum.reduce(aggregate, &@aggregate_module.apply(&2, &1))
      end
    end
  end
end
