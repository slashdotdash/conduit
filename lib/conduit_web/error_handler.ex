defmodule ConduitWeb.ErrorHandler do
  import Plug.Conn

  @behaviour Guardian.Plug.ErrorHandler

  @impl Guardian.Plug.ErrorHandler
  def auth_error(conn, {_type, _reason}, _opts), do: respond_with(conn, :unauthorized)

  @doc """
  Return 401 for "Unauthorized" requests

  A request requires authentication but it isn't provided
  """
  def unauthenticated(conn, _params), do: respond_with(conn, :unauthorized)

  @doc """
  Return 403 for "Forbidden" requests

  A request may be valid, but the user doesn't have permissions to perform the action
  """
  def unauthorized(conn, _params), do: respond_with(conn, :forbidden)

  @doc """
  Return 401 for "Unauthorized" requests

  A request requires authentication but the resource has not been found
  """
  def no_resource(conn, _params), do: respond_with(conn, :unauthorized)

  defp respond_with(conn, status) do
    conn
    |> put_resp_content_type("application/json")
    |> send_resp(status, "")
  end
end
