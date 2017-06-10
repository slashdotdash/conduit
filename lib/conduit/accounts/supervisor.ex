defmodule Conduit.Accounts.Supervisor do
  use Supervisor

  alias Conduit.Accounts
  
  def start_link do
    Supervisor.start_link(__MODULE__, [], name: __MODULE__)
  end

  def init(_arg) do
    Supervisor.init([
      Accounts.Projectors.User
    ], strategy: :one_for_one)
  end
end
