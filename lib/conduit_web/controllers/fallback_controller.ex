defmodule ConduitWeb.FallbackController do
  use ConduitWeb, :controller

  def call(conn,  {:error, :validation_failure, errors}) do
    conn
    |> put_status(:unprocessable_entity)
    |> render(ConduitWeb.ValidationView, "error.json", errors: errors)
  end

  def call(conn, {:error, :not_found}) do
    conn
    |> put_status(:not_found)
    |> render(ConduitWeb.ErrorView, :"404")
  end
end
