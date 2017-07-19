defmodule Conduit.Blog.Projectors.Tag do
  use Commanded.Projections.Ecto, name: "Blog.Projectors.Tag"

  alias Conduit.Blog.Projections.Tag
  alias Conduit.Blog.Events.ArticlePublished

  project %ArticlePublished{tags: tags} do
    Enum.reduce(tags, multi, fn (tag, multi) ->
      Ecto.Multi.insert(multi, "tag-#{tag}", %Tag{name: tag},
        on_conflict: :nothing,
        conflict_target: :name)
    end)
  end
end
