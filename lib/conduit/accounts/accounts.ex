defmodule Conduit.Accounts do
  @moduledoc """
  The boundary for the Accounts system.
  """

  alias Conduit.Accounts.Commands.{RegisterUser, UpdateUser}
  alias Conduit.Accounts.Projections.User
  alias Conduit.Accounts.Queries.{UserByUsername, UserByEmail}
  alias Conduit.App
  alias Conduit.Repo

  @doc """
  Register a new user.
  """
  def register_user(attrs \\ %{}) do
    uuid = UUID.uuid4()

    register_user =
      attrs
      |> RegisterUser.new()
      |> RegisterUser.assign_uuid(uuid)
      |> RegisterUser.downcase_username()
      |> RegisterUser.downcase_email()
      |> RegisterUser.hash_password()

    with :ok <- App.dispatch(register_user, consistency: :strong) do
      get(User, uuid)
    end
  end

  @doc """
  Update the email, username, and/or password of a user.
  """
  def update_user(%User{uuid: user_uuid} = user, attrs \\ %{}) do
    update_user =
      attrs
      |> UpdateUser.new()
      |> UpdateUser.assign_user(user)
      |> UpdateUser.downcase_username()
      |> UpdateUser.downcase_email()
      |> UpdateUser.hash_password()

    with :ok <- App.dispatch(update_user, consistency: :strong) do
      get(User, user_uuid)
    end
  end

  @doc """
  Get an existing user by their username, or return `nil` if not registered
  """
  def user_by_username(username) when is_binary(username) do
    username
    |> String.downcase()
    |> UserByUsername.new()
    |> Repo.one()
  end

  @doc """
  Get an existing user by their email address, or return `nil` if not registered
  """
  def user_by_email(email) when is_binary(email) do
    email
    |> String.downcase()
    |> UserByEmail.new()
    |> Repo.one()
  end

  @doc """
  Get a single user by their UUID
  """
  def user_by_uuid(uuid) when is_binary(uuid) do
    Repo.get(User, uuid)
  end

  defp get(schema, uuid) do
    case Repo.get(schema, uuid) do
      nil -> {:error, :not_found}
      projection -> {:ok, projection}
    end
  end
end
