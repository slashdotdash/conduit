defmodule ConduitWeb.Router do
  use ConduitWeb, :router

  alias ConduitWeb.Plugs

  pipeline :api do
    plug :accepts, ["json"]

    plug Guardian.Plug.Pipeline,
      error_handler: ConduitWeb.ErrorHandler,
      module: Conduit.Auth.Guardian

    plug Guardian.Plug.VerifyHeader, realm: "Token"
    plug Guardian.Plug.LoadResource, allow_blank: true
  end

  pipeline :article do
    plug Plugs.LoadArticleBySlug
  end

  scope "/api", ConduitWeb do
    pipe_through :api

    get "/articles", ArticleController, :index
    get "/articles/feed", ArticleController, :feed
    get "/articles/:slug", ArticleController, :show
    post "/articles", ArticleController, :create

    scope "/articles/:slug" do
      pipe_through :article

      get "/comments", CommentController, :index
      post "/comments", CommentController, :create
      delete "/comments/:uuid", CommentController, :delete

      post "/favorite", FavoriteArticleController, :create
      delete "/favorite", FavoriteArticleController, :delete
    end

    get "/profiles/:username", ProfileController, :show
    post "/profiles/:username/follow", ProfileController, :follow
    delete "/profiles/:username/follow", ProfileController, :unfollow

    get "/tags", TagController, :index

    get "/user", UserController, :current
    post "/users/login", SessionController, :create
    post "/users", UserController, :create
    put "/user", UserController, :update
  end
end
