defmodule Conduit.Accounts.Events.UserEmailChanged do
  @derive Jason.Encoder
  defstruct [
    :user_uuid,
    :email,
  ]
end
