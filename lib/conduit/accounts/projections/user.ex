defmodule Conduit.Accounts.Projections.User do
  use Ecto.Schema

  import Ecto.Changeset
  
  alias Conduit.Accounts.Projections.User

  schema "accounts_users" do
    field :username, :string, unique: true
    field :email, :string, unique: true
    field :hashed_password, :string
    field :bio, :string
    field :image, :string

    timestamps()
  end

  @doc false
  def changeset(%User{} = user, attrs) do
    user
    |> cast(attrs, [:username, :email, :hashed_password, :bio, :image])
    |> validate_required([:username, :email, :hashed_password, :bio, :image])
  end
end
