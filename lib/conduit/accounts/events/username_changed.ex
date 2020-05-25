defmodule Conduit.Accounts.Events.UsernameChanged do
  @derive Jason.Encoder
  defstruct [
    :user_uuid,
    :username
  ]
end
