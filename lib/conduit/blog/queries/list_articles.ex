defmodule Conduit.Blog.Queries.ListArticles do
  import Ecto.Query

  alias Conduit.Blog.Projections.Article

  defmodule Options do
    defstruct [
      author: nil,
      limit: 20,
      offset: 0,
    ]

    use ExConstructor
  end

  def paginate(params, repo) do
    options = Options.new(params)
    query = options |> query()

    articles = query |> entries(options) |> repo.all()
    total_count = query |> count() |> repo.aggregate(:count, :uuid)

    {articles, total_count}
  end

  defp query(options) do
    from(a in Article)
    |> filter_by_author(options)
  end

  defp entries(query, %Options{limit: limit, offset: offset}) do
    query
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
end
