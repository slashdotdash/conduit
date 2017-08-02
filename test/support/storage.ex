defmodule Conduit.Storage do
  @doc """
  Clear the event store and read store databases
  """
  def reset! do
    :ok = Application.stop(:conduit)
    :ok = Application.stop(:commanded)
    :ok = Application.stop(:eventstore)

    reset_eventstore()
    reset_readstore()

    {:ok, _} = Application.ensure_all_started(:conduit)
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
  blog_articles,
  blog_authors,
  blog_comments,
  blog_favorited_articles,
  blog_feed_articles,
  blog_tags,
  projection_versions
RESTART IDENTITY;
"""
  end
end
