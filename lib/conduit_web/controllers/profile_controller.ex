defmodule ConduitWeb.ProfileController do
  use ConduitWeb, :controller

  alias Conduit.Blog
  alias Conduit.Blog.Projections.Author
  alias ConduitWeb.ProfileView

  plug(Guardian.Plug.EnsureAuthenticated when action in [:follow, :unfollow])

  action_fallback(ConduitWeb.FallbackController)

  def show(conn, %{"username" => username}) do
    user = Guardian.Plug.current_resource(conn)
    follower = Blog.get_author(user)
    author = Blog.author_by_username!(username, follower)

    render(conn, "show.json", author: author)
  end

  def follow(conn, %{"username" => username}) do
    user = Guardian.Plug.current_resource(conn)
    author = Blog.author_by_username!(username)
    follower = Blog.get_author!(user.uuid)

    with {:ok, %Author{} = author} <- Blog.follow_author(author, follower) do
      conn
      |> put_status(:created)
      |> put_view(ProfileView)
      |> render("show.json", author: author)
    end
  end

  def unfollow(conn, %{"username" => username}) do
    user = Guardian.Plug.current_resource(conn)
    author = Blog.author_by_username!(username)
    unfollower = Blog.get_author!(user.uuid)

    with {:ok, %Author{} = author} <- Blog.unfollow_author(author, unfollower) do
      conn
      |> put_status(:created)
      |> put_view(ProfileView)
      |> render("show.json", author: author)
    end
  end
end
