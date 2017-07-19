defmodule Conduit.Blog.Queries.ListArticles do
  import Ecto.Query

  alias Conduit.Blog.Projections.{Article,Author,FavoritedArticle}

  defmodule Options do
    defstruct [
      author: nil,
      favorited: nil,
      limit: 20,
      offset: 0,
      tag: nil,
    ]

    use ExConstructor
  end

  def paginate(params, author, repo) do
    options = Options.new(params)
    query = query(options)

    articles = query |> entries(options, author) |> repo.all()
    total_count = query |> count() |> repo.aggregate(:count, :uuid)

    {articles, total_count}
  end

  defp query(options) do
    from(a in Article)
    |> filter_by_author(options)
    |> filter_by_tag(options)
    |> filter_favorited_by_user(options)
  end

  defp entries(query, %Options{limit: limit, offset: offset}, author) do
    query
    |> include_favorited_by_author(author)
    |> order_by([a], desc: a.published_at)
    |> limit(^limit)
    |> offset(^offset)
  end

  defp count(query) do
    query |> select([:uuid])
  end

  defp filter_by_author(query, %Options{author: nil}), do: query
  defp filter_by_author(query, %Options{author: author}) do
    query |> where(author_username: ^author)
  end

  defp filter_by_tag(query, %Options{tag: nil}), do: query
  defp filter_by_tag(query, %Options{tag: tag}) do
    from a in query,
    where: fragment("? @> ?", a.tags, [^tag])
  end

  defp filter_favorited_by_user(query, %Options{favorited: nil}), do: query
  defp filter_favorited_by_user(query, %Options{favorited: favorited}) do
    from a in query,
    join: f in FavoritedArticle, on: [article_uuid: a.uuid, favorited_by_username: ^favorited]
  end

  defp include_favorited_by_author(query, nil), do: query
  defp include_favorited_by_author(query, %Author{uuid: author_uuid}) do
    from a in query,
    left_join: f in FavoritedArticle, on: [article_uuid: a.uuid, favorited_by_author_uuid: ^author_uuid],
    select: %{a | favorited: not is_nil(f.article_uuid)}
  end
end
