defmodule Conduit.Application do
  use Application

  def start(_type, _args) do
    import Supervisor.Spec

    children = [
      # Start the Ecto repository
      supervisor(Conduit.Repo, []),

      # Start the endpoint when the application starts
      supervisor(ConduitWeb.Endpoint, []),

      # Accounts supervisor
      supervisor(Conduit.Accounts.Supervisor, []),
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
