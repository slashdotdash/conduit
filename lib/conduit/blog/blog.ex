defmodule Conduit.Blog do
  @moduledoc """
  The boundary for the Blog system.
  """

  alias Conduit.Accounts.Projections.User
  alias Conduit.Blog.Commands.{FavoriteArticle,CommentOnArticle,CreateAuthor,DeleteComment,FavoriteArticle,PublishArticle,UnfavoriteArticle}
  alias Conduit.Blog.Projections.{Article,Author,Comment}
  alias Conduit.Blog.Queries.{ArticleBySlug,ArticleComments,ListArticles,ListTags}
  alias Conduit.{Repo,Router}

  @doc """
  Get the author for a given uuid, or raise an `Ecto.NoResultsError` if not found.
  """
  def get_author!(uuid), do: Repo.get!(Author, uuid)

  @doc """
  Get the author for a given uuid, or nil if the user is nil.
  """
  def get_author(nil), do: nil
  def get_author(%User{uuid: user_uuid}), do: get_author(user_uuid)
  def get_author(uuid) when is_bitstring(uuid), do: Repo.get(Author, uuid)

  @doc """
  Get an article by its URL slug, or return `nil` if not found
  """
  def article_by_slug(slug),
    do: article_by_slug_query(slug) |> Repo.one()

  @doc """
  Get an article by its URL slug, or raise an `Ecto.NoResultsError` if not found.
  """
  def article_by_slug!(slug),
    do: article_by_slug_query(slug) |> Repo.one!()

  @doc """
  Get an author by their username, or raise an `Ecto.NoResultsError` if not found
  """
  def author_by_username!(username), do: Repo.get_by!(Author, username: username)

  @doc """
  Returns most recent articles globally by default.

  Provide tag, author, or favorited query parameter to filter results.
  """
  @spec list_articles(params :: map(), author :: Author.t) :: {articles :: list(Article.t), article_count :: non_neg_integer()}
  def list_articles(params \\ %{}, author \\ nil)
  def list_articles(params, author) do
    ListArticles.paginate(params, author, Repo)
  end

  @doc """
  List all tags.
  """
  def list_tags do
    ListTags.new() |> Repo.all() |> Enum.map(&(&1.name))
  end

  @doc """
  Get comments on an article.
  """
  def article_comments(%Article{uuid: article_uuid}) do
    article_uuid
    |> ArticleComments.new()
    |> Repo.all()
  end

  @doc """
  Get a comment by its UUID, or raise an `Ecto.NoResultsError` if not found
  """
  def get_comment!(comment_uuid), do: Repo.get!(Comment, comment_uuid)

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

    with :ok <- Router.dispatch(publish_article, consistency: :strong) do
      get(Article, uuid)
    else
      reply -> reply
    end
  end

  @doc """
  Favorite the article for an author
  """
  def favorite_article(%Article{uuid: article_uuid}, %Author{uuid: author_uuid}) do
    favorite_article = %FavoriteArticle{
      article_uuid: article_uuid,
      favorited_by_author_uuid: author_uuid,
    }

    with :ok <- Router.dispatch(favorite_article, consistency: :strong),
         {:ok, article} <- get(Article, article_uuid) do
      {:ok, %Article{article | favorited: true}}
    else
      reply -> reply
    end
  end

  @doc """
  Unfavorite the article for an author
  """
  def unfavorite_article(%Article{uuid: article_uuid}, %Author{uuid: author_uuid}) do
    unfavorite_article = %UnfavoriteArticle{
      article_uuid: article_uuid,
      unfavorited_by_author_uuid: author_uuid,
    }

    with :ok <- Router.dispatch(unfavorite_article, consistency: :strong),
         {:ok, article} <- get(Article, article_uuid) do
      {:ok, %Article{article | favorited: false}}
    else
      reply -> reply
    end
  end

  @doc """
  Add a comment to an article
  """
  def comment_on_article(%Article{} = article, %Author{} = author, attrs \\ %{}) do
    uuid = UUID.uuid4()

    comment_on_article =
      attrs
      |> CommentOnArticle.new()
      |> CommentOnArticle.assign_uuid(uuid)
      |> CommentOnArticle.assign_article(article)
      |> CommentOnArticle.assign_author(author)

    with :ok <- Router.dispatch(comment_on_article, consistency: :strong) do
      get(Comment, uuid)
    else
      reply -> reply
    end
  end

  @doc """
  Delete a comment made by the user. Returns `:ok` on success
  """
  def delete_comment(%Comment{} = comment, %Author{} = author) do
    delete_comment =
      %DeleteComment{}
      |> DeleteComment.assign_comment(comment)
      |> DeleteComment.deleted_by(author)

    Router.dispatch(delete_comment)
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
