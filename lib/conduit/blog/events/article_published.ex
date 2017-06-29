defmodule Conduit.Blog.Events.ArticlePublished do
  @derive [Poison.Encoder]
  defstruct [
    :article_uuid,
    :author_uuid,
    :slug,
    :title,
    :description,
    :body,
    :tags,
  ]
end
