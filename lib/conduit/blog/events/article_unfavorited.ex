defmodule Conduit.Blog.Events.ArticleUnfavorited do
  @derive Jason.Encoder
  defstruct [
    :article_uuid,
    :unfavorited_by_author_uuid,
    :favorite_count,
  ]
end
