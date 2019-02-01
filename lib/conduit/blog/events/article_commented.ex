defmodule Conduit.Blog.Events.ArticleCommented do
  @derive Jason.Encoder
  defstruct [
    :comment_uuid,
    :body,
    :article_uuid,
    :author_uuid,
  ]
end
