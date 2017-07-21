defmodule Conduit.Repo.Migrations.CreateBlogComment do
  use Ecto.Migration

  def change do
    create table(:blog_comments, primary_key: false) do
      add :uuid, :uuid, primary_key: true
      add :body, :text
      add :article_uuid, :uuid
      add :author_uuid, :uuid
      add :author_username, :text
      add :author_bio, :text
      add :author_image, :text
      add :commented_at, :naive_datetime

      timestamps()
    end

    create index(:blog_comments, [:article_uuid])
    create index(:blog_comments, [:author_uuid])
    create index(:blog_comments, [:commented_at])
  end
end
