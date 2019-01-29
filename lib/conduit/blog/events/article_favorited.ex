defmodule Conduit.Blog.Events.ArticleFavorited do
  @derive Jason.Encoder
  defstruct [
    :article_uuid,
    :favorited_by_author_uuid,
    :favorite_count,
  ]
end
