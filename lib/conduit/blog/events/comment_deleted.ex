defmodule Conduit.Blog.Events.CommentDeleted do
  @derive [Poison.Encoder]
  defstruct [
    :comment_uuid,
    :article_uuid,
    :author_uuid,
  ]
end
