defmodule Conduit.Accounts.Aggregates.User do
  defstruct [
    :uuid,
    :username,
    :email,
    :hashed_password
  ]

  alias Conduit.Commanded.UncommittedChanges
  alias Conduit.Accounts.Aggregates.User

  alias Conduit.Accounts.Commands.{
    RegisterUser,
    UpdateUser
  }

  alias Conduit.Accounts.Events.{
    UserEmailChanged,
    UsernameChanged,
    UserPasswordChanged,
    UserRegistered
  }

  @doc """
  Register a new user
  """
  def execute(%User{uuid: nil}, %RegisterUser{} = register) do
    %UserRegistered{
      user_uuid: register.user_uuid,
      username: register.username,
      email: register.email,
      hashed_password: register.hashed_password
    }
  end

  @doc """
  Update a user's username, email, and password
  """
  def execute(%User{} = user, %UpdateUser{} = update) do
    UncommittedChanges.new()
    |> username_changed(user, update)
    |> email_changed(user, update)
    |> password_changed(user, update)
    |> UncommittedChanges.get_events()
  end

  # state mutators

  def apply(%User{} = user, %UserRegistered{} = registered) do
    %User{
      user
      | uuid: registered.user_uuid,
        username: registered.username,
        email: registered.email,
        hashed_password: registered.hashed_password
    }
  end

  def apply(%User{} = user, %UsernameChanged{username: username}) do
    %User{user | username: username}
  end

  def apply(%User{} = user, %UserEmailChanged{email: email}) do
    %User{user | email: email}
  end

  def apply(%User{} = user, %UserPasswordChanged{hashed_password: hashed_password}) do
    %User{user | hashed_password: hashed_password}
  end

  # private helpers

  defp username_changed(changes, %User{}, %UpdateUser{username: ""}), do: changes

  defp username_changed(changes, %User{username: username}, %UpdateUser{username: username}),
    do: changes

  defp username_changed(changes, %User{uuid: user_uuid}, %UpdateUser{username: username}) do
    UncommittedChanges.append_event(changes, %UsernameChanged{
      user_uuid: user_uuid,
      username: username
    })
  end

  defp email_changed(changes, %User{}, %UpdateUser{email: ""}), do: changes
  defp email_changed(changes, %User{email: email}, %UpdateUser{email: email}), do: changes

  defp email_changed(changes, %User{uuid: user_uuid}, %UpdateUser{email: email}) do
    UncommittedChanges.append_event(changes, %UserEmailChanged{
      user_uuid: user_uuid,
      email: email
    })
  end

  defp password_changed(changes, %User{}, %UpdateUser{hashed_password: ""}), do: changes

  defp password_changed(changes, %User{hashed_password: hashed_password}, %UpdateUser{
         hashed_password: hashed_password
       }),
       do: changes

  defp password_changed(changes, %User{uuid: user_uuid}, %UpdateUser{
         hashed_password: hashed_password
       }) do
    UncommittedChanges.append_event(changes, %UserPasswordChanged{
      user_uuid: user_uuid,
      hashed_password: hashed_password
    })
  end
end
