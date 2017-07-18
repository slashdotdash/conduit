defmodule Conduit.Repo.Migrations.AddIndexToBlogTags do
  use Ecto.Migration

  def change do
    create index(:blog_articles, [:tags], using: "GIN")
  end
end
