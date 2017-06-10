defmodule Conduit.DataCase do
  @moduledoc """
  This module defines the setup for tests requiring
  access to the application's data layer.

  You may define functions here to be used as helpers in
  your tests.

  Finally, if the test case interacts with the database,
  it cannot be async. For this reason, every test runs
  inside a transaction which is reset at the beginning
  of the test unless the test case is marked as async.
  """

  use ExUnit.CaseTemplate

  using do
    quote do
      alias Conduit.Repo

      import Ecto
      import Ecto.Changeset
      import Ecto.Query
      import Conduit.Factory
      import Conduit.DataCase
    end
  end

  setup do
    Application.stop(:conduit)
    Application.stop(:commanded)
    Application.stop(:eventstore)
    
    reset_eventstore()
    reset_readstore()

    Application.ensure_all_started(:conduit)

    :ok
  end

  defp reset_eventstore do
    {:ok, conn} =
      EventStore.configuration()
      |> EventStore.Config.parse()
      |> Postgrex.start_link()

    EventStore.Storage.Initializer.reset!(conn)
  end

  defp reset_readstore do
    readstore_config = Application.get_env(:conduit, Conduit.Repo)

    {:ok, conn} = Postgrex.start_link(readstore_config)

    Postgrex.query!(conn, truncate_readstore_tables(), [])
  end

  defp truncate_readstore_tables do
"""
TRUNCATE TABLE
  accounts_users,
  projection_versions
RESTART IDENTITY;
"""
  end
end
