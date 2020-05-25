defmodule Conduit.Accounts.Commands.RegisterUser do
  defstruct user_uuid: "",
            username: "",
            email: "",
            password: "",
            hashed_password: ""

  use ExConstructor
  use Vex.Struct

  alias Conduit.Accounts.Commands.RegisterUser
  alias Conduit.Accounts.Validators.{UniqueEmail, UniqueUsername}
  alias Conduit.Auth

  validates(:user_uuid, uuid: true)

  validates(:username,
    presence: [message: "can't be empty"],
    format: [with: ~r/^[a-z0-9]+$/, allow_nil: true, allow_blank: true, message: "is invalid"],
    string: true,
    by: &UniqueUsername.validate/2
  )

  validates(:email,
    presence: [message: "can't be empty"],
    format: [with: ~r/\S+@\S+\.\S+/, allow_nil: true, allow_blank: true, message: "is invalid"],
    string: true,
    by: &UniqueEmail.validate/2
  )

  validates(:hashed_password, presence: [message: "can't be empty"], string: true)

  @doc """
  Assign a unique identity for the user
  """
  def assign_uuid(%RegisterUser{} = register_user, uuid) do
    %RegisterUser{register_user | user_uuid: uuid}
  end

  @doc """
  Convert username to lowercase characters
  """
  def downcase_username(%RegisterUser{username: username} = register_user) do
    %RegisterUser{register_user | username: String.downcase(username)}
  end

  @doc """
  Convert email address to lowercase characters
  """
  def downcase_email(%RegisterUser{email: email} = register_user) do
    %RegisterUser{register_user | email: String.downcase(email)}
  end

  @doc """
  Hash the password, clear the original password
  """
  def hash_password(%RegisterUser{password: password} = register_user) do
    %RegisterUser{register_user | password: nil, hashed_password: Auth.hash_password(password)}
  end
end

defimpl Conduit.Support.Middleware.Uniqueness.UniqueFields,
  for: Conduit.Accounts.Commands.RegisterUser do
  def unique(%Conduit.Accounts.Commands.RegisterUser{user_uuid: user_uuid}),
    do: [
      {:email, "has already been taken", user_uuid},
      {:username, "has already been taken", user_uuid}
    ]
end
