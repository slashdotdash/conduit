defmodule Conduit.Blog.Events.AuthorFollowed do
  @derive Jason.Encoder
  defstruct [
    :author_uuid,
    :followed_by_author_uuid
  ]
end
