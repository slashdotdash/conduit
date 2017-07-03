defmodule Conduit.Blog.Queries.ListArticles do
  import Ecto.Query

  alias Conduit.Blog.Projections.Article

  defmodule Options do
    defstruct [
      limit: 20,
      offset: 0,
    ]

    use ExConstructor
  end

  def paginate(params, repo) do
    options = Options.new(params)

    articles = query() |> entries(options) |> repo.all()
    total_count = query() |> count() |> repo.aggregate(:count, :uuid)

    {articles, total_count}
  end

  defp query do
    from(a in Article)
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
end
