defmodule Conduit.AggregateCase do
  @moduledoc """
  This module defines the test case to be used by aggregate tests.
  """

  use ExUnit.CaseTemplate

  using aggregate: aggregate do
    quote bind_quoted: [aggregate: aggregate] do
      @aggregate_module aggregate

      import Conduit.Factory

      # Assert that the expected events are returned when the given commands have been executed
      defp assert_events(commands, expected_events) do
        assert_events([], commands, expected_events)
      end

      defp assert_events(initial_events, commands, expected_events) do
        {_aggregate, events} =
          %@aggregate_module{}
          |> evolve(initial_events)
          |> execute(commands)

        actual_events = List.wrap(events)

        assert expected_events == actual_events
      end

      # Execute one or more commands against an aggregate
      defp execute(aggregate, commands) do
        commands
        |> List.wrap()
        |> Enum.reduce({aggregate, []}, fn command, {aggregate, _} ->
          events = @aggregate_module.execute(aggregate, command)

          {evolve(aggregate, events), events}
        end)
      end

      # Apply the given events to the aggregate state
      defp evolve(aggregate, events) do
        events
        |> List.wrap()
        |> Enum.reduce(aggregate, &@aggregate_module.apply(&2, &1))
      end
    end
  end
end
