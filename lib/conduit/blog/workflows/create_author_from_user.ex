defmodule Conduit.Blog.Workflows.CreateAuthorFromUser do
  use Commanded.Event.Handler,
    name: "Blog.Workflows.CreateAuthorFromUser",
    consistency: :strong

  alias Conduit.Accounts.Events.UserRegistered
  alias Conduit.Blog.Commands.CreateAuthor
  alias Conduit.Router

  def handle(%UserRegistered{user_uuid: user_uuid, username: username}, _metadata) do
    create_author = %CreateAuthor{
      author_uuid: user_uuid,
      user_uuid: user_uuid,
      username: username,
    }

    Router.dispatch(create_author)
  end
end
