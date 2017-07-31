defmodule Conduit.Blog.Events.AuthorCreated do
  @derive [Poison.Encoder]
  defstruct [
    :author_uuid,
    :user_uuid,
    :username,
  ]
end
