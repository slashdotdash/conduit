defmodule Conduit.Blog.Workflows.CreateAuthorFromUser do
  use Commanded.Event.Handler,
    name: "Blog.Workflows.CreateAuthorFromUser",
    consistency: :strong

  alias Conduit.Accounts.Events.UserRegistered
  alias Conduit.Blog
  
  def handle(%UserRegistered{user_uuid: user_uuid, username: username}, _metadata) do
    with {:ok, _author} <- Blog.create_author(%{user_uuid: user_uuid, username: username}) do
      :ok
    else
      reply -> reply
    end
  end
end
