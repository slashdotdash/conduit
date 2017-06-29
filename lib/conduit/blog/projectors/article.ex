defmodule Conduit.Blog.Projectors.Article do
  use Commanded.Projections.Ecto,
    name: "Blog.Projectors.Article",
    consistency: :strong

  alias Conduit.Blog.Events.{ArticlePublished,AuthorCreated}
  alias Conduit.Blog.Projections.{Article,Author}
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

  project %ArticlePublished{} = published, %{created_at: published_at} do
    multi
    |> Ecto.Multi.run(:author, fn _changes -> get_author(published.author_uuid) end)
    |> Ecto.Multi.run(:article, fn %{author: author} ->
      article = %Article{
        uuid: published.article_uuid,
        slug: published.slug,
        title: published.title,
        description: published.description,
        body: published.body,
        tags: published.tags,
        favorite_count: 0,
        published_at: published_at,
        author_uuid: author.uuid,
        author_username: author.username,
        author_bio: author.bio,
        author_image: author.image,
      }

      Repo.insert(article)
    end)
  end

  defp get_author(uuid) do
    case Repo.get(Author, uuid) do
      nil -> {:error, :author_not_found}
      author -> {:ok, author}
    end
  end
end
