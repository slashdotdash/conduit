defmodule Conduit.Blog.Commands.FollowAuthor do
  defstruct [
    author_uuid: "",
    follower_uuid: "",
  ]

  use ExConstructor
  use Vex.Struct

  validates :author_uuid, uuid: true
  validates :follower_uuid, uuid: true
end
