defmodule Conduit.Application do
  use Application

  def start(_type, _args) do
    children = [
      # Commanded application
      Conduit.App,

      # Start the Ecto repository
      Conduit.Repo,

      # Start the Phoenix PubSub system
      {Phoenix.PubSub, name: Conduit.PubSub},

      # Start the endpoint when the application starts
      ConduitWeb.Endpoint,

      # Accounts supervisor
      Conduit.Accounts.Supervisor,

      # Blog supervisor
      Conduit.Blog.Supervisor,

      # Enforce unique constraints
      Conduit.Support.Unique
    ]

    opts = [strategy: :one_for_one, name: Conduit.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  def config_change(changed, _new, removed) do
    ConduitWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
