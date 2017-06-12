defmodule Conduit.Router do
  use Commanded.Commands.Router

  alias Conduit.Accounts.Aggregates.User
  alias Conduit.Accounts.Commands.RegisterUser
  alias Conduit.Support.Middleware.Validation

  middleware Validation

  dispatch [RegisterUser], to: User, identity: :user_uuid
end
