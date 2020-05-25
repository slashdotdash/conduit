defmodule Conduit.Blog.Commands.DeleteComment do
  defstruct comment_uuid: "",
            deleted_by_author_uuid: ""

  use ExConstructor
  use Vex.Struct

  alias Conduit.Blog.Projections.{Author, Comment}
  alias Conduit.Blog.Commands.DeleteComment

  validates(:comment_uuid, uuid: true)
  validates(:deleted_by_author_uuid, uuid: true)

  def assign_comment(%DeleteComment{} = delete, %Comment{uuid: comment_uuid}) do
    %DeleteComment{delete | comment_uuid: comment_uuid}
  end

  def deleted_by(%DeleteComment{} = delete, %Author{uuid: author_uuid}) do
    %DeleteComment{delete | deleted_by_author_uuid: author_uuid}
  end
end
