defmodule Conduit.Blog.Projections.Comment do
  use Ecto.Schema

  @primary_key {:uuid, :binary_id, autogenerate: false}

  schema "blog_comments" do
    field :body, :string
    field :article_uuid, :binary_id
    field :author_uuid, :binary_id
    field :author_bio, :string
    field :author_image, :string
    field :author_username, :string
    field :commented_at, :naive_datetime

    timestamps()
  end
end
