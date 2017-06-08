defmodule Conduit.Accounts do
  @moduledoc """
  The boundary for the Accounts system.
  """

  alias Conduit.Accounts.Commands.RegisterUser
  alias Conduit.Router

  @doc """
  Register a new user.
  """
  def register_user(attrs \\ %{}) do
    attrs
    |> assign_uuid(:user_uuid)
    |> RegisterUser.new()
    |> Router.dispatch()
  end

  # generate a unique identity
  defp assign_uuid(attrs, identity), do: Map.put(attrs, identity, UUID.uuid4())
end
