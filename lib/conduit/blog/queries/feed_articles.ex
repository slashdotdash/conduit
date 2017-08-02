defmodule Conduit.Blog.Queries.FeedArticles do
  import Ecto.Query

  alias Conduit.Blog.Projections.{Article,Author,FavoritedArticle,Feed}

  defmodule Options do
    defstruct [
      limit: 20,
      offset: 0,
    ]

    use ExConstructor
  end

  def paginate(params, author, repo) do
    options = Options.new(params)
    query = query(author)

    articles = query |> entries(options, author) |> repo.all()
    total_count = query |> count() |> repo.aggregate(:count, :article_uuid)

    {articles, total_count}
  end

  defp query(%Author{uuid: author_uuid}) do
    from(f in Feed, where: [follower_uuid: ^author_uuid])
  end

  defp entries(query, %Options{limit: limit, offset: offset}, author) do
    query
    |> order_by([feed], desc: feed.published_at)
    |> join_and_select_article()
    |> include_favorited_by_author(author)
    |> limit(^limit)
    |> offset(^offset)
  end

  defp count(query) do
    query |> select([:article_uuid, :follower_uuid])
  end

  defp join_and_select_article(query) do
    from f in query,
    join: a in Article, on: a.uuid == f.article_uuid
  end

  defp include_favorited_by_author(query, %Author{uuid: author_uuid}) do
    from [feed, a] in query,
    left_join: f in FavoritedArticle, on: [article_uuid: a.uuid, favorited_by_author_uuid: ^author_uuid],
    select: %{a | favorited: not is_nil(f.article_uuid)}
  end
end
