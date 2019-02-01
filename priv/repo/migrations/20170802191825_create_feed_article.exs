defmodule Conduit.Repo.Migrations.CreateFeedArticle do
  use Ecto.Migration

  def change do
    create table(:blog_feed_articles, primary_key: false) do
      add(:article_uuid, :uuid, primary_key: true)
      add(:follower_uuid, :uuid, primary_key: true)
      add(:author_uuid, :uuid)
      add(:published_at, :naive_datetime_usec)

      timestamps()
    end

    create(index(:blog_feed_articles, [:follower_uuid]))
    create(index(:blog_feed_articles, [:author_uuid]))
    create(index(:blog_feed_articles, [:published_at]))
  end
end
