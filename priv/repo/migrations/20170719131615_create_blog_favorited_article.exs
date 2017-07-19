defmodule Conduit.Repo.Migrations.CreateBlogFavoritedArticle do
  use Ecto.Migration

  def change do
    create table(:blog_favorited_articles, primary_key: false) do
      add :article_uuid, :uuid, primary_key: true
      add :favorited_by_author_uuid, :uuid, primary_key: true
      add :favorited_by_username, :text

      timestamps()
    end
  end
end
