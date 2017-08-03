defmodule Conduit.Accounts.Commands.UpdateUser do
  defstruct [
    user_uuid: "",
    username: "",
    email: "",
    password: "",
    hashed_password: "",
  ]

  use ExConstructor
  use Vex.Struct

  alias Conduit.Accounts.Commands.UpdateUser
  alias Conduit.Accounts.Projections.User
  alias Conduit.Accounts.Validators.{UniqueEmail,UniqueUsername}
  alias Conduit.Auth

  validates :user_uuid, uuid: true

  validates :username,
    presence: [message: "can't be empty"],
    format: [with: ~r/^[a-z0-9]+$/, allow_nil: true, allow_blank: true, message: "is invalid"],
    string: true,
    by: &UniqueUsername.validate/2

  validates :email,
    presence: [message: "can't be empty"],
    format: [with: ~r/\S+@\S+\.\S+/, allow_nil: true, allow_blank: true, message: "is invalid"],
    string: true,
    by: &UniqueEmail.validate/2

  validates :hashed_password, string: [allow_nil: true, allow_blank: true]

  @doc """
  Assign the user identity
  """
  def assign_user(%UpdateUser{} = update_user, %User{uuid: user_uuid}) do
    %UpdateUser{update_user | user_uuid: user_uuid}
  end

  @doc """
  Convert username to lowercase characters
  """
  def downcase_username(%UpdateUser{username: username} = update_user) do
    %UpdateUser{update_user | username: String.downcase(username)}
  end

  @doc """
  Convert email address to lowercase characters
  """
  def downcase_email(%UpdateUser{email: email} = update_user) do
    %UpdateUser{update_user | email: String.downcase(email)}
  end

  @doc """
  Hash the password, clear the original password
  """
  def hash_password(%UpdateUser{password: ""} = update_user), do: update_user
  def hash_password(%UpdateUser{password: password} = update_user) do
    %UpdateUser{update_user |
      password: nil,
      hashed_password: Auth.hash_password(password),
    }
  end
end

defimpl Conduit.Support.Middleware.Uniqueness.UniqueFields, for: Conduit.Accounts.Commands.UpdateUser do
  def unique(%Conduit.Accounts.Commands.UpdateUser{user_uuid: user_uuid}), do: [
    {:email, "has already been taken", user_uuid},
    {:username, "has already been taken", user_uuid},
  ]
end
