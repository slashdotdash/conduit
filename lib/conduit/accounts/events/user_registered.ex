defmodule Conduit.Accounts.Events.UserRegistered do
  @derive Jason.Encoder
  defstruct [
    :user_uuid,
    :username,
    :email,
    :hashed_password,
  ]
end
