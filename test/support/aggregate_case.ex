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
        assert_events(%@aggregate_module{}, commands, expected_events)
      end

      defp assert_events(aggregate, commands, expected_events) do
        {_aggregate, events, error} = execute(commands, aggregate)

        assert is_nil(error)
        assert List.wrap(events) == expected_events
      end

      defp assert_error(commands, expected_error) do
        assert_error(%@aggregate_module{}, commands, expected_error)
      end

      defp assert_error(aggregate, commands, expected_error) do
        {_aggregate, _events, error} = execute(commands, aggregate)

        assert error == expected_error
      end

      # execute one or more commands against an aggregate
      defp execute(commands, aggregate \\ %@aggregate_module{})
      defp execute(commands, aggregate) do
        commands
        |> List.wrap()
        |> Enum.reduce({aggregate, [], nil}, fn
          (command, {aggregate, _events, nil}) ->
            case @aggregate_module.execute(aggregate, command) do
              {:error, reason} = error -> {aggregate, nil, error}
              events -> {evolve(aggregate, events), events, nil}
            end
          (command, {aggregate, _events, _error} = reply) -> reply
        end)
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
