defmodule ConduitWeb.FavoriteArticleController do
  use ConduitWeb, :controller

  alias Conduit.Blog
  alias Conduit.Blog.Projections.Article
  alias ConduitWeb.ArticleView

  plug(Guardian.Plug.EnsureAuthenticated when action in [:create, :delete])

  action_fallback(ConduitWeb.FallbackController)

  def create(%{assigns: %{article: article}} = conn, _params) do
    user = Guardian.Plug.current_resource(conn)
    author = Blog.get_author!(user.uuid)

    with {:ok, %Article{} = article} <- Blog.favorite_article(article, author) do
      conn
      |> put_status(:created)
      |> put_view(ArticleView)
      |> render("show.json", article: article)
    end
  end

  def delete(%{assigns: %{article: article}} = conn, _params) do
    user = Guardian.Plug.current_resource(conn)    
    author = Blog.get_author!(user.uuid)

    with {:ok, %Article{} = article} <- Blog.unfavorite_article(article, author) do
      conn
      |> put_status(:created)
      |> put_view(ArticleView)
      |> render("show.json", article: article)
    end
  end
end
