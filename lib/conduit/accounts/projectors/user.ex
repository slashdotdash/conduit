defmodule Conduit.Accounts.Projectors.User do
  use Commanded.Projections.Ecto,
    name: "Accounts.Projectors.User",
    consistency: :strong

  alias Conduit.Accounts.Events.UserRegistered
  alias Conduit.Accounts.Projections.User

  project %UserRegistered{} = registered do
    Ecto.Multi.insert(multi, :user, %User{
      uuid: registered.user_uuid,
      username: registered.username,
      email: registered.email,
      hashed_password: registered.hashed_password,
      bio: nil,
      image: nil,
    })
  end
end
