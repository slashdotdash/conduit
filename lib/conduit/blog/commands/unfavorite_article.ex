defmodule Conduit.Blog.Commands.UnfavoriteArticle do
  defstruct [
    article_uuid: "",
    unfavorited_by_author_uuid: "",
  ]

  use ExConstructor
  use Vex.Struct

  validates :article_uuid, uuid: true
  validates :unfavorited_by_author_uuid, uuid: true
end
