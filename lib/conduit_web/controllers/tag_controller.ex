defmodule ConduitWeb.TagController do
  use ConduitWeb, :controller

  alias Conduit.Blog

  action_fallback(ConduitWeb.FallbackController)

  def index(conn, _params) do
    tags = Blog.list_tags()
    render(conn, "index.json", tags: tags)
  end
end
