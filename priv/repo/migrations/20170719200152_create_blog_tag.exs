defmodule Conduit.Repo.Migrations.CreateBlogTag do
  use Ecto.Migration

  def change do
    create table(:blog_tags, primary_key: false) do
      add :uuid, :uuid, primary_key: true
      add :name, :string

      timestamps()
    end

    create unique_index(:blog_tags, [:name])
  end
end
