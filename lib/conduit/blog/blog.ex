defmodule Conduit.Blog do
  @moduledoc """
  The boundary for the Blog system.
  """

  import Ecto.Query, warn: false

  alias Conduit.Blog.Projections.Article
  alias Conduit.Blog.Commands.CreateAuthor
  alias Conduit.Blog.Projections.Author
  alias Conduit.{Repo,Router}

  @doc """
  Create an author.
  An author shares the same uuid as the user, but with a different prefix.
  """
  def create_author(%{user_uuid: uuid} = attrs) do
    create_author =
      attrs
      |> CreateAuthor.new()
      |> CreateAuthor.assign_uuid(uuid)

    with :ok <- Router.dispatch(create_author, consistency: :strong) do
      get(Author, uuid)
    else
      reply -> reply
    end
  end

  defp get(schema, uuid) do
    case Repo.get(schema, uuid) do
      nil -> {:error, :not_found}
      projection -> {:ok, projection}
    end
  end
end
