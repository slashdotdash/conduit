defmodule Conduit.Accounts.Queries.UserByEmail do
  import Ecto.Query

  alias Conduit.Accounts.Projections.User

  def new(email) do
    from u in User,
    where: u.email == ^email
  end
end
