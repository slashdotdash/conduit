defmodule ConduitWeb.Plugs.LoadArticleBySlug do
  use Phoenix.Controller, namespace: ConduitWeb

  import Plug.Conn

  alias Conduit.Blog

  def init(opts), do: opts

  def call(%Plug.Conn{params: %{"slug" => slug}} = conn, _opts) do
    article = Blog.article_by_slug!(slug)

    assign(conn, :article, article)
  end
end
