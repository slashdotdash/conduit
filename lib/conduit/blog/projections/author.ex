defmodule Conduit.Blog.Projections.Author do
  use Ecto.Schema

  @primary_key {:uuid, :binary_id, autogenerate: false}
  @timestamps_opts [type: :utc_datetime_usec]

  schema "blog_authors" do
    field :user_uuid, :binary_id
    field :username, :string
    field :bio, :string
    field :image, :string
    field :followers, {:array, :binary_id}, default: []
    field :following, :boolean, virtual: true, default: false

    timestamps()
  end
end
