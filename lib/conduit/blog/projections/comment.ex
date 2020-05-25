defmodule Conduit.Blog.Projections.Comment do
  use Ecto.Schema

  @primary_key {:uuid, :binary_id, autogenerate: false}
  @timestamps_opts [type: :utc_datetime_usec]

  schema "blog_comments" do
    field(:body, :string)
    field(:article_uuid, :binary_id)
    field(:author_uuid, :binary_id)
    field(:author_bio, :string)
    field(:author_image, :string)
    field(:author_username, :string)
    field(:commented_at, :utc_datetime_usec)

    timestamps()
  end
end
