defmodule Conduit.Blog.Projections.FavoritedArticle do
  use Ecto.Schema

  @primary_key false

  schema "blog_favorited_articles" do
    field :article_uuid, :binary_id, primary_key: true
    field :favorited_by_author_uuid, :binary_id, primary_key: true

    timestamps()
  end
end
