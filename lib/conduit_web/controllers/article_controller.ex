defmodule ConduitWeb.ArticleController do
  use ConduitWeb, :controller

  alias Conduit.Blog
  alias Conduit.Blog.Projections.Article

  plug(Guardian.Plug.EnsureAuthenticated when action in [:create, :feed])

  action_fallback(ConduitWeb.FallbackController)

  def index(conn, params) do
    user = Guardian.Plug.current_resource(conn)
    author = Blog.get_author(user)

    {articles, total_count} = Blog.list_articles(params, author)

    render(conn, "index.json", articles: articles, total_count: total_count)
  end

  def feed(conn, params) do
    user = Guardian.Plug.current_resource(conn)
    author = Blog.get_author(user)

    {articles, total_count} = Blog.feed_articles(params, author)

    render(conn, "index.json", articles: articles, total_count: total_count)
  end

  def show(conn, %{"slug" => slug}) do
    article = Blog.article_by_slug!(slug)
    render(conn, "show.json", article: article)
  end

  def create(conn, %{"article" => article_params}) do
    user = Guardian.Plug.current_resource(conn)
    author = Blog.get_author!(user.uuid)

    with {:ok, %Article{} = article} <- Blog.publish_article(author, article_params) do
      conn
      |> put_status(:created)
      |> render("show.json", article: article)
    end
  end
end
