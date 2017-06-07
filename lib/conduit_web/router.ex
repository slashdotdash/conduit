defmodule ConduitWeb.Router do
  use ConduitWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api", ConduitWeb do
    pipe_through :api

    post "/users", UserController, :create
  end
end
