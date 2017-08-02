defmodule Conduit.Blog.Projectors.Article do
  use Commanded.Projections.Ecto,
    name: "Blog.Projectors.Article",
    consistency: :strong

  alias Conduit.Blog.Projections.{Article,Author,Comment,FavoritedArticle}
  alias Conduit.Blog.Events.{
    ArticleCommented,
    ArticleFavorited,
    ArticlePublished,
    ArticleUnfavorited,
    AuthorCreated,
    AuthorFollowed,
    AuthorUnfollowed,
    CommentDeleted,
  }
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

  project %AuthorFollowed{author_uuid: author_uuid, followed_by_author_uuid: follower_uuid} do
    Ecto.Multi.update_all(multi, :author, author_query(author_uuid), push: [
      followers: follower_uuid,
    ])
  end

  project %AuthorUnfollowed{author_uuid: author_uuid, unfollowed_by_author_uuid: follower_uuid} do
    Ecto.Multi.update_all(multi, :author, author_query(author_uuid), pull: [
      followers: follower_uuid,
    ])
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

  project %ArticleCommented{} = commented, %{created_at: commented_at} do
    multi
    |> Ecto.Multi.run(:author, fn _changes -> get_author(commented.author_uuid) end)
    |> Ecto.Multi.run(:comment, fn %{author: author} ->
      comment = %Comment{
        uuid: commented.comment_uuid,
        body: commented.body,
        article_uuid: commented.article_uuid,
        author_uuid: author.uuid,
        author_username: author.username,
        author_bio: author.bio,
        author_image: author.image,
        commented_at: commented_at,
      }

      Repo.insert(comment)
    end)
  end

  project %CommentDeleted{comment_uuid: comment_uuid} do
    Ecto.Multi.delete_all(multi, :comment, comment_query(comment_uuid))
  end

  @doc """
  Favorite article for the user and update the article's favorite count
  """
  project %ArticleFavorited{article_uuid: article_uuid, favorited_by_author_uuid: favorited_by_author_uuid, favorite_count: favorite_count} do
    multi
    |> Ecto.Multi.run(:author, fn _changes -> get_author(favorited_by_author_uuid) end)
    |> Ecto.Multi.run(:favorited_article, fn %{author: author} ->
      favorite = %FavoritedArticle{
        article_uuid: article_uuid,
        favorited_by_author_uuid: favorited_by_author_uuid,
        favorited_by_username: author.username,
      }

      Repo.insert(favorite)
    end)
    |> Ecto.Multi.update_all(:article, article_query(article_uuid), set: [
      favorite_count: favorite_count,
    ])
  end

  @doc """
  Delete the user's favorite and update the article's favorite count
  """
  project %ArticleUnfavorited{article_uuid: article_uuid, unfavorited_by_author_uuid: unfavorited_by_author_uuid, favorite_count: favorite_count} do
    multi
    |> Ecto.Multi.delete_all(:favorited_article, favorited_article_query(article_uuid, unfavorited_by_author_uuid))
    |> Ecto.Multi.update_all(:article, article_query(article_uuid), set: [
      favorite_count: favorite_count,
    ])
  end

  defp get_author(uuid) do
    case Repo.get(Author, uuid) do
      nil -> {:error, :author_not_found}
      author -> {:ok, author}
    end
  end

  defp author_query(author_uuid) do
    from(a in Author, where: a.uuid == ^author_uuid)
  end

  defp article_query(article_uuid) do
    from(a in Article, where: a.uuid == ^article_uuid)
  end

  defp comment_query(comment_uuid) do
    from(c in Comment, where: c.uuid == ^comment_uuid)
  end

  defp favorited_article_query(article_uuid, author_uuid) do
    from(f in FavoritedArticle, where: f.article_uuid == ^article_uuid and f.favorited_by_author_uuid == ^author_uuid)
  end
end
