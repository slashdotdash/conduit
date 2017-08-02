defmodule ConduitWeb.ProfileController do
  use ConduitWeb, :controller
  use Guardian.Phoenix.Controller

  alias Conduit.Blog
  alias Conduit.Blog.Projections.Author
  alias ConduitWeb.ProfileView

  plug Guardian.Plug.EnsureAuthenticated, %{handler: ConduitWeb.ErrorHandler} when action in [:follow, :unfollow]
  plug Guardian.Plug.EnsureResource, %{handler: ConduitWeb.ErrorHandler} when action in [:follow, :unfollow]

  action_fallback ConduitWeb.FallbackController

  def show(conn, %{"username" => username}, user, _claims) do
    follower = Blog.get_author(user)
    author = Blog.author_by_username!(username, follower)

    render(conn, "show.json", author: author)
  end

  def follow(conn, %{"username" => username}, user, _claims) do
    author = Blog.author_by_username!(username)
    follower = Blog.get_author!(user.uuid)

    with {:ok, %Author{} = author} <- Blog.follow_author(author, follower) do
      conn
      |> put_status(:created)
      |> render(ProfileView, "show.json", author: author)
    end
  end

  def unfollow(conn, %{"username" => username}, user, _claims) do
    author = Blog.author_by_username!(username)
    unfollower = Blog.get_author!(user.uuid)

    with {:ok, %Author{} = author} <- Blog.unfollow_author(author, unfollower) do
      conn
      |> put_status(:created)
      |> render(ProfileView, "show.json", author: author)
    end
  end
end
