defmodule Conduit.Repo.Migrations.CreateConduit.Blog.Author do
  use Ecto.Migration

  def change do
    create table(:blog_authors, primary_key: false) do
      add :uuid, :uuid, primary_key: true
      add :user_uuid, :uuid
      add :username, :string
      add :bio, :string
      add :image, :string

      timestamps()
    end

    create unique_index(:blog_authors, [:user_uuid])
  end
end
