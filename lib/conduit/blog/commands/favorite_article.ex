defmodule Conduit.Blog.Commands.FavoriteArticle do
  defstruct article_uuid: "",
            favorited_by_author_uuid: ""

  use ExConstructor
  use Vex.Struct

  validates(:article_uuid, uuid: true)
  validates(:favorited_by_author_uuid, uuid: true)
end
