defmodule Conduit.Blog.Aggregates.Comment do
  defstruct [
    uuid: nil,
    body: nil,
    article_uuid: nil,
    author_uuid: nil,
  ]

  alias Conduit.Blog.Aggregates.Comment

  alias Conduit.Blog.Commands.{
    CommentOnArticle,
  }

  alias Conduit.Blog.Events.{
    ArticleCommented,
  }

  @doc """
  Comment on an article
  """
  def execute(%Comment{uuid: nil}, %CommentOnArticle{} = comment) do
    %ArticleCommented{
      comment_uuid: comment.comment_uuid,
      body: comment.body,
      article_uuid: comment.article_uuid,
      author_uuid: comment.author_uuid,
    }
  end

  # state mutators

  def apply(%Comment{} = comment, %ArticleCommented{} = commented) do
    %Comment{comment |
      uuid: commented.comment_uuid,
      body: commented.body,
      article_uuid: commented.article_uuid,
      author_uuid: commented.author_uuid,
    }
  end
end
