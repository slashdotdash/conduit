defmodule ConduitWeb.UserController do
  use ConduitWeb, :controller

  alias Conduit.Accounts
  alias Conduit.Accounts.Projections.User
  alias Conduit.Blog
  alias Conduit.Blog.Projections.Author

  action_fallback(ConduitWeb.FallbackController)

  plug(Guardian.Plug.EnsureAuthenticated when action in [:current])

  def create(conn, %{"user" => user_params}) do
    with {:ok, %User{} = user} <- Accounts.register_user(user_params),
         {:ok, jwt} = generate_jwt(user) do
      conn
      |> put_status(:created)
      |> render("show.json", user: user, jwt: jwt)
    end
  end

  def current(conn, _params) do
    user = Conduit.Auth.Guardian.Plug.current_resource(conn)
    jwt = Conduit.Auth.Guardian.Plug.current_token(conn)

    conn
    |> put_status(:ok)
    |> render("show.json", user: user, jwt: jwt)
  end

  def update(conn, %{"user" => user_params}) do
    user = Guardian.Plug.current_resource(conn)
    author = Blog.get_author!(user.uuid)

    with {:ok, %User{} = user} <- Accounts.update_user(user, user_params),
         {:ok, %Author{} = author} <- Blog.update_author_profile(author, user_params),
         {:ok, jwt} = generate_jwt(user) do
      conn
      |> put_status(:ok)
      |> render("show.json", author: author, user: user, jwt: jwt)
    end
  end
end
