defmodule ConduitWeb.ProfileController do
  use ConduitWeb, :controller

  alias Conduit.Blog

  action_fallback ConduitWeb.FallbackController

  def show(conn, %{"username" => username}) do
    author = Blog.author_by_username!(username)
    render(conn, "show.json", author: author)
  end
end
