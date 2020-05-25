defmodule Conduit.Blog.Commands.UnfollowAuthor do
  defstruct author_uuid: "",
            unfollower_uuid: ""

  use ExConstructor
  use Vex.Struct

  validates(:author_uuid, uuid: true)
  validates(:unfollower_uuid, uuid: true)
end
