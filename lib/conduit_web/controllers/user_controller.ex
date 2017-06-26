defmodule ConduitWeb.UserController do
  use ConduitWeb, :controller

  alias Conduit.Accounts
  alias Conduit.Accounts.Projections.User

  action_fallback ConduitWeb.FallbackController

  def create(conn, %{"user" => user_params}) do
    with {:ok, %User{} = user} <- Accounts.register_user(user_params),
         {:ok, jwt} = generate_jwt(user) do
      conn
      |> put_status(:created)
      |> render("show.json", user: user, jwt: jwt)
    end
  end
end
