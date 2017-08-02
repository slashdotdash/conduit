defmodule Conduit.Repo.Migrations.AddFollowersToAuthor do
  use Ecto.Migration

  def change do
    alter table(:blog_authors) do
      add :followers, {:array, :binary_id}
    end
  end
end
