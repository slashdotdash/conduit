defmodule Conduit.Repo.Migrations.CreateConduit.Blog.Article do
  use Ecto.Migration

  def change do
    create table(:blog_articles, primary_key: false) do
      add(:uuid, :uuid, primary_key: true)
      add(:slug, :text)
      add(:title, :text)
      add(:description, :text)
      add(:body, :text)
      add(:tag_list, {:array, :text})
      add(:favorite_count, :integer)
      add(:published_at, :utc_datetime_usec)
      add(:author_uuid, :uuid)
      add(:author_username, :text)
      add(:author_bio, :text)
      add(:author_image, :text)

      timestamps()
    end

    create(unique_index(:blog_articles, [:slug]))
    create(index(:blog_articles, [:author_uuid]))
    create(index(:blog_articles, [:author_username]))
    create(index(:blog_articles, [:published_at]))
  end
end
