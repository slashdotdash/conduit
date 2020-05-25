defmodule Conduit.Blog.Queries.ArticleComments do
  import Ecto.Query

  alias Conduit.Blog.Projections.Comment

  def new(article_uuid) do
    from(c in Comment,
      where: c.article_uuid == ^article_uuid,
      order_by: [desc: c.commented_at]
    )
  end
end
