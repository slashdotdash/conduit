defmodule ConduitWeb.SessionController do
  use ConduitWeb, :controller

  alias Conduit.Auth
  alias Conduit.Accounts.Projections.User

  action_fallback ConduitWeb.FallbackController

  def create(conn, %{"user" => %{"email" => email, "password" => password}}) do
    case Auth.authenticate(email, password) do
      {:ok, %User{} = user} ->
        conn
        |> put_status(:created)
        |> render(ConduitWeb.UserView, "show.json", user: user)

      {:error, :unauthenticated} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(ConduitWeb.ValidationView, "error.json", errors: %{"email or password" => ["is invalid"]})
    end
  end
end
