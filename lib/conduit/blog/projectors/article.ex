defmodule Conduit.Blog.Projectors.Article do
  use Commanded.Projections.Ecto,
    name: "Blog.Projectors.Article",
    consistency: :strong

  alias Conduit.Blog.Events.AuthorCreated
  alias Conduit.Blog.Projections.Author
  alias Conduit.Repo

  project %AuthorCreated{} = author do
    Ecto.Multi.insert(multi, :author, %Author{
      uuid: author.author_uuid,
      user_uuid: author.user_uuid,
      username: author.username,
      bio: nil,
      image: nil,
    })
  end
end
