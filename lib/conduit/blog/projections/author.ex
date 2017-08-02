defmodule Conduit.Blog.Projections.Author do
  use Ecto.Schema

  @primary_key {:uuid, :binary_id, autogenerate: false}

  schema "blog_authors" do
    field :user_uuid, :binary_id
    field :username, :string
    field :bio, :string
    field :image, :string
    field :following, :boolean, virtual: true, default: false

    timestamps()
  end
end
