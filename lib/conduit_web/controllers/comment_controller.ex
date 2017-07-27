defmodule ConduitWeb.CommentController do
  use ConduitWeb, :controller
  use Guardian.Phoenix.Controller

  alias Conduit.Blog
  alias Conduit.Blog.Projections.Comment

  plug Guardian.Plug.EnsureAuthenticated, %{handler: ConduitWeb.ErrorHandler} when action in [:create, :delete]
  plug Guardian.Plug.EnsureResource, %{handler: ConduitWeb.ErrorHandler} when action in [:create, :delete]

  action_fallback ConduitWeb.FallbackController

  def index(%{assigns: %{article: article}} = conn, _params, _user, _claims) do
    comments = Blog.article_comments(article)
    render(conn, "index.json", comments: comments)
  end

  def create(%{assigns: %{article: article}} = conn, %{"comment" => comment_params}, user, _claims) do
    author = Blog.get_author!(user.uuid)

    with {:ok, %Comment{} = comment} <- Blog.comment_on_article(article, author, comment_params) do
      conn
      |> put_status(:created)
      |> render("show.json", comment: comment)
    end
  end
end
