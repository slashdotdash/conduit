defmodule ConduitWeb.UserController do
  use ConduitWeb, :controller
  use Guardian.Phoenix.Controller

  alias Conduit.Accounts
  alias Conduit.Accounts.Projections.User

  action_fallback ConduitWeb.FallbackController

  plug Guardian.Plug.EnsureAuthenticated, %{handler: ConduitWeb.ErrorHandler} when action in [:current]
  plug Guardian.Plug.EnsureResource, %{handler: ConduitWeb.ErrorHandler} when action in [:current]

  def create(conn, %{"user" => user_params}, _user, _claims) do
    with {:ok, %User{} = user} <- Accounts.register_user(user_params),
         {:ok, jwt} = generate_jwt(user) do
      conn
      |> put_status(:created)
      |> render("show.json", user: user, jwt: jwt)
    end
  end

  def current(conn, _params, user, _claims) do
    jwt = Guardian.Plug.current_token(conn)

    conn
    |> put_status(:ok)
    |> render("show.json", user: user, jwt: jwt)
  end
end
