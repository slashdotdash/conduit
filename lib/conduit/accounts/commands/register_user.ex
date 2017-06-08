defmodule Conduit.Accounts.Commands.RegisterUser do
  defstruct [
    :uuid,
    :username,
    :email,
    :password,
    :hashed_password,
  ]

  use ExConstructor
end
