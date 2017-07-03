defmodule ConduitWeb.ArticleController do
  use ConduitWeb, :controller
  use Guardian.Phoenix.Controller

  alias Conduit.Blog
  alias Conduit.Blog.Projections.Article

  plug Guardian.Plug.EnsureAuthenticated, %{handler: ConduitWeb.ErrorHandler} when action in [:create]
  plug Guardian.Plug.EnsureResource, %{handler: ConduitWeb.ErrorHandler} when action in [:create]

  action_fallback ConduitWeb.FallbackController

  def index(conn, params, _user, _claims) do
    {articles, total_count} = Blog.list_articles(params)
    render(conn, "index.json", articles: articles, total_count: total_count)
  end

  def create(conn, %{"article" => article_params}, user, _claims) do
    author = Blog.get_author!(user.uuid)

    with {:ok, %Article{} = article} <- Blog.publish_article(author, article_params) do
      conn
      |> put_status(:created)
      |> render("show.json", article: article)
    end
  end
end
