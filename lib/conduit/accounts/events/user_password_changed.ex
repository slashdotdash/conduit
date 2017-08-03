defmodule Conduit.Accounts.Events.UserPasswordChanged do
  @derive [Poison.Encoder]
  defstruct [
    :user_uuid,
    :hashed_password,
  ]
end
