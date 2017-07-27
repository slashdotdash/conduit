defmodule Conduit.Blog.Commands.CommentOnArticle do
  defstruct [
    comment_uuid: "",
    body: "",
    article_uuid: "",
    author_uuid: "",
  ]

  use ExConstructor
  use Vex.Struct

  alias Conduit.Blog.Projections.{Article,Author}
  alias Conduit.Blog.Commands.CommentOnArticle

  validates :comment_uuid, uuid: true
  validates :body, presence: [message: "can't be empty"], string: true
  validates :article_uuid, uuid: true
  validates :author_uuid, uuid: true

  def assign_uuid(%CommentOnArticle{} = comment, uuid) do
    %CommentOnArticle{comment | comment_uuid: uuid}
  end

  def assign_article(%CommentOnArticle{} = comment, %Article{uuid: article_uuid}) do
    %CommentOnArticle{comment | article_uuid: article_uuid}
  end

  def assign_author(%CommentOnArticle{} = comment, %Author{uuid: author_uuid}) do
    %CommentOnArticle{comment | author_uuid: author_uuid}
  end
end
