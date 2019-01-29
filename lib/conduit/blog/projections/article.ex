defmodule Conduit.Blog.Projections.Article do
  use Ecto.Schema

  @primary_key {:uuid, :binary_id, autogenerate: false}
  @timestamps_opts [type: :naive_datetime_usec]
  schema "blog_articles" do
    field(:slug, :string)
    field(:title, :string)
    field(:description, :string)
    field(:body, :string)
    field(:tag_list, {:array, :string})
    field(:favorited, :boolean, virtual: true, default: false)
    field(:favorite_count, :integer, default: 0)
    field(:published_at, :naive_datetime_usec)
    field(:author_uuid, :binary_id)
    field(:author_bio, :string)
    field(:author_image, :string)
    field(:author_username, :string)

    timestamps()
  end
end
