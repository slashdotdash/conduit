defmodule ConduitWeb.Router do
  use ConduitWeb, :router

  alias ConduitWeb.Plugs

  pipeline :api do
    plug :accepts, ["json"]
    plug Guardian.Plug.VerifyHeader, realm: "Token"
    plug Guardian.Plug.LoadResource
  end

  pipeline :article do
    plug Plugs.LoadArticleBySlug
  end

  scope "/api", ConduitWeb do
    pipe_through :api

    get "/articles", ArticleController, :index
    get "/articles/:slug", ArticleController, :show
    post "/articles", ArticleController, :create

    scope "/articles/:slug" do
      pipe_through :article

      post "/favorite", FavoriteArticleController, :create
      delete "/favorite", FavoriteArticleController, :delete
    end

    get "/user", UserController, :current
    post "/users/login", SessionController, :create
    post "/users", UserController, :create
  end
end
