defmodule Conduit.Blog.Events.AuthorUnfollowed do
  @derive Jason.Encoder
  defstruct [
    :author_uuid,
    :unfollowed_by_author_uuid,
  ]
end
