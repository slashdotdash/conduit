defmodule ConduitWeb.ConnHelpers do
  import Plug.Conn
  import Conduit.Fixture

  alias ConduitWeb.JWT

  def authenticated_conn(conn) do
    with {:ok, user} <- fixture(:user),
         {:ok, jwt} <- JWT.generate_jwt(user)
    do
      conn
      |> put_req_header("authorization", "Token " <> jwt)
    end
  end
end
