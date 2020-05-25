defmodule Conduit.Accounts.Events.UserPasswordChanged do
  @derive Jason.Encoder
  defstruct [
    :user_uuid,
    :hashed_password
  ]
end
