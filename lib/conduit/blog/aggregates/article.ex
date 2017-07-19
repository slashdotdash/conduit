defmodule Conduit.Blog.Aggregates.Article do
  defstruct [
    uuid: nil,
    slug: nil,
    title: nil,
    description: nil,
    body: nil,
    tags: nil,
    author_uuid: nil,
    favorited_by_authors: MapSet.new(),
    favorite_count: 0,
  ]

  alias Conduit.Blog.Aggregates.Article

  alias Conduit.Blog.Commands.{
    FavoriteArticle,
    PublishArticle,
    UnfavoriteArticle,
  }

  alias Conduit.Blog.Events.{
    ArticleFavorited,
    ArticlePublished,
    ArticleUnfavorited,
  }

  @doc """
  Publish an article
  """
  def execute(%Article{uuid: nil}, %PublishArticle{} = publish) do
    %ArticlePublished{
      article_uuid: publish.article_uuid,
      slug: publish.slug,
      title: publish.title,
      description: publish.description,
      body: publish.body,
      tags: publish.tag_list,
      author_uuid: publish.author_uuid,
    }
  end

  @doc """
  Favorite the article for an author
  """
  def execute(%Article{uuid: nil}, %FavoriteArticle{}), do: {:error, :article_not_found}
  def execute(
    %Article{uuid: uuid, favorite_count: favorite_count} = article,
    %FavoriteArticle{favorited_by_author_uuid: author_id})
  do
    case is_favorited?(article, author_id) do
      true -> nil
      false ->
        %ArticleFavorited{
          article_uuid: uuid,
          favorited_by_author_uuid: author_id,
          favorite_count: favorite_count + 1,
        }
    end
  end

  @doc """
  Unfavorite the article for the user
  """
  def execute(%Article{uuid: nil}, %UnfavoriteArticle{}), do: {:error, :article_not_found}
  def execute(
    %Article{uuid: uuid, favorite_count: favorite_count} = article,
    %UnfavoriteArticle{unfavorited_by_author_uuid: author_id})
  do
    case is_favorited?(article, author_id) do
      true ->
        %ArticleUnfavorited{
          article_uuid: uuid,
          unfavorited_by_author_uuid: author_id,
          favorite_count: favorite_count - 1,
        }
      false -> nil
    end
  end

  # state mutators

  def apply(%Article{} = article, %ArticlePublished{} = published) do
    %Article{article |
      uuid: published.article_uuid,
      slug: published.slug,
      title: published.title,
      description: published.description,
      body: published.body,
      tags: published.tags,
      author_uuid: published.author_uuid,
    }
  end

  def apply(
    %Article{favorited_by_authors: favorited_by} = article,
    %ArticleFavorited{favorited_by_author_uuid: author_id, favorite_count: favorite_count})
  do
    %Article{article |
      favorited_by_authors: MapSet.put(favorited_by, author_id),
      favorite_count: favorite_count,
    }
  end

  def apply(
    %Article{favorited_by_authors: favorited_by} = article,
    %ArticleUnfavorited{unfavorited_by_author_uuid: author_id, favorite_count: favorite_count})
  do
    %Article{article |
      favorited_by_authors: MapSet.delete(favorited_by, author_id),
      favorite_count: favorite_count,
    }
  end

  # private helpers

  # Is the article a favorite of the user?
  defp is_favorited?(%Article{favorited_by_authors: favorited_by}, user_uuid) do
    MapSet.member?(favorited_by, user_uuid)
  end
end
