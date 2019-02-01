defmodule ConduitWeb.FavoriteArticleController do
  use ConduitWeb, :controller
  use Guardian.Phoenix.Controller

  alias Conduit.Blog
  alias Conduit.Blog.Projections.Article
  alias ConduitWeb.ArticleView

  plug(
    Guardian.Plug.EnsureAuthenticated,
    %{handler: ConduitWeb.ErrorHandler} when action in [:create, :delete]
  )

  plug(
    Guardian.Plug.EnsureResource,
    %{handler: ConduitWeb.ErrorHandler} when action in [:create, :delete]
  )

  action_fallback(ConduitWeb.FallbackController)

  def create(%{assigns: %{article: article}} = conn, _params, user, _claims) do
    author = Blog.get_author!(user.uuid)

    with {:ok, %Article{} = article} <- Blog.favorite_article(article, author) do
      conn
      |> put_status(:created)
      |> put_view(ArticleView)
      |> render("show.json", article: article)
    end
  end

  def delete(%{assigns: %{article: article}} = conn, _params, user, _claims) do
    author = Blog.get_author!(user.uuid)

    with {:ok, %Article{} = article} <- Blog.unfavorite_article(article, author) do
      conn
      |> put_status(:created)
      |> put_view(ArticleView)
      |> render("show.json", article: article)
    end
  end
end
