defmodule ConduitWeb.CommentController do
  use ConduitWeb, :controller

  alias Conduit.Blog
  alias Conduit.Blog.Projections.Comment

  plug(Guardian.Plug.EnsureAuthenticated when action in [:create, :delete])

  action_fallback(ConduitWeb.FallbackController)

  def index(%{assigns: %{article: article}} = conn, _params) do
    comments = Blog.article_comments(article)
    render(conn, "index.json", comments: comments)
  end

  def create(%{assigns: %{article: article}} = conn, %{"comment" => comment_params}) do
    user = Guardian.Plug.current_resource(conn)
    author = Blog.get_author!(user.uuid)

    with {:ok, %Comment{} = comment} <- Blog.comment_on_article(article, author, comment_params) do
      conn
      |> put_status(:created)
      |> render("show.json", comment: comment)
    end
  end

  def delete(conn, %{"uuid" => comment_uuid}) do
    user = Guardian.Plug.current_resource(conn)
    author = Blog.get_author!(user.uuid)
    comment = Blog.get_comment!(comment_uuid)

    with :ok <- Blog.delete_comment(comment, author) do
      send_resp(conn, :no_content, "")
    end
  end
end
