defmodule Conduit.Support.Middleware.Uniqueness do
  @behaviour Commanded.Middleware

  defprotocol UniqueFields do
    @fallback_to_any true
    @doc "Returns unique fields for the command"
    def unique(command)
  end

  defimpl UniqueFields, for: Any do
    def unique(_command), do: []
  end

  alias Conduit.Support.Unique
  alias Commanded.Middleware.Pipeline

  import Pipeline

  def before_dispatch(%Pipeline{command: command} = pipeline) do
    case ensure_uniqueness(command) do
      :ok ->
        pipeline

      {:error, errors} ->
        pipeline
        |> respond({:error, :validation_failure, errors})
        |> halt()
    end
  end

  def after_dispatch(pipeline), do: pipeline
  def after_failure(pipeline), do: pipeline

  defp ensure_uniqueness(command) do
    command
    |> UniqueFields.unique()
    |> Enum.reduce_while(:ok, fn ({unique_field, error_message, owner}, _) ->
      value = Map.get(command, unique_field)

      case Unique.claim(unique_field, owner, value) do
        :ok -> {:cont, :ok}
        {:error, :already_taken} -> {:halt, {:error, Keyword.new([{unique_field, error_message}])}}
      end
    end)
  end
end
