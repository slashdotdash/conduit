defmodule ConduitWeb.SessionController do
  use ConduitWeb, :controller

  alias Conduit.Auth
  alias Conduit.Accounts.Projections.User

  action_fallback ConduitWeb.FallbackController

  def create(conn, %{"user" => %{"email" => email, "password" => password}}) do
    with {:ok, %User{} = user} <- Auth.authenticate(email, password),
         {:ok, jwt} <- generate_jwt(user) do
       conn
        |> put_status(:created)
        |> render(ConduitWeb.UserView, "show.json", user: user, jwt: jwt)
    else
      {:error, :unauthenticated} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(ConduitWeb.ValidationView, "error.json", errors: %{"email or password" => ["is invalid"]})
    end
  end
end
