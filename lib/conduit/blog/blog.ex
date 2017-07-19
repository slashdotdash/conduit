defmodule Conduit.Blog do
  @moduledoc """
  The boundary for the Blog system.
  """

  alias Conduit.Blog.Commands.{CreateAuthor,FavoriteArticle,PublishArticle,UnfavoriteArticle}
  alias Conduit.Blog.Projections.{Article,Author}
  alias Conduit.Blog.Queries.{ArticleBySlug,ListArticles}
  alias Conduit.{Repo,Router}

  @doc """
  Get the author for a given uuid.
  """
  def get_author!(uuid) do
    Repo.get!(Author, uuid)
  end

  @doc """
  Get an article by its URL slug, or return `nil` if not found
  """
  def article_by_slug(slug),
    do: article_by_slug_query(slug) |> Repo.one()

  @doc """
  Get an article by its URL slug, or raise an `Ecto.NoResultsError` if not found
  """
  def article_by_slug!(slug),
    do: article_by_slug_query(slug) |> Repo.one!()

  @doc """
  Returns most recent articles globally by default.

  Provide tag, author or favorited query parameter to filter results.
  """
  @spec list_articles(params :: map()) :: {articles :: list(Article.t), article_count :: non_neg_integer()}
  def list_articles(params \\ %{}) do
    ListArticles.paginate(params, Repo)
  end

  @doc """
  Create an author.

  An author shares the same uuid as the user, but with a different prefix.
  """
  def create_author(%{user_uuid: uuid} = attrs) do
    create_author =
      attrs
      |> CreateAuthor.new()
      |> CreateAuthor.assign_uuid(uuid)

    with :ok <- Router.dispatch(create_author, consistency: :strong) do
      get(Author, uuid)
    else
      reply -> reply
    end
  end

  @doc """
  Publishes an article by the given author.
  """
  def publish_article(%Author{} = author, attrs \\ %{}) do
    uuid = UUID.uuid4()

    publish_article =
      attrs
      |> PublishArticle.new()
      |> PublishArticle.assign_uuid(uuid)
      |> PublishArticle.assign_author(author)
      |> PublishArticle.generate_url_slug()

    dispatch(publish_article, uuid)
  end

  @doc """
  Favorite the article for an author
  """
  def favorite_article(%Article{uuid: article_uuid}, %Author{uuid: author_uuid}) do
    favorite_article = %FavoriteArticle{
      article_uuid: article_uuid,
      favorited_by_author_uuid: author_uuid,
    }

    dispatch(favorite_article, article_uuid)
  end

  @doc """
  Unfavorite the article for an author
  """
  def unfavorite_article(%Article{uuid: article_uuid}, %Author{uuid: author_uuid}) do
    unfavorite_article = %UnfavoriteArticle{
      article_uuid: article_uuid,
      unfavorited_by_author_uuid: author_uuid,
    }

    dispatch(unfavorite_article, article_uuid)
  end

  defp dispatch(command, article_uuid) do
    with :ok <- Router.dispatch(command, consistency: :strong) do
      get(Article, article_uuid)
    else
      reply -> reply
    end
  end

  defp get(schema, uuid) do
    case Repo.get(schema, uuid) do
      nil -> {:error, :not_found}
      projection -> {:ok, projection}
    end
  end

  defp article_by_slug_query(slug) do
    slug
    |> String.downcase()
    |> ArticleBySlug.new()
  end
end
