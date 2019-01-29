defmodule Conduit.Blog.Aggregates.Comment do
  @behaviour Commanded.Aggregates.AggregateLifespan

  defstruct uuid: nil,
            body: nil,
            article_uuid: nil,
            author_uuid: nil,
            deleted?: false

  alias Conduit.Blog.Aggregates.Comment

  alias Conduit.Blog.Commands.{
    CommentOnArticle,
    DeleteComment
  }

  alias Conduit.Blog.Events.{
    ArticleCommented,
    CommentDeleted
  }

  @doc """
  Comment on an article
  """
  def execute(%Comment{uuid: nil}, %CommentOnArticle{} = comment) do
    %ArticleCommented{
      comment_uuid: comment.comment_uuid,
      body: comment.body,
      article_uuid: comment.article_uuid,
      author_uuid: comment.author_uuid
    }
  end

  @doc """
  Delete a comment made by the user
  """
  def execute(
        %Comment{
          uuid: comment_uuid,
          article_uuid: article_uuid,
          author_uuid: author_uuid,
          deleted?: false
        },
        %DeleteComment{comment_uuid: comment_uuid, deleted_by_author_uuid: deleted_by_author_uuid}
      ) do
    case deleted_by_author_uuid do
      ^author_uuid ->
        %CommentDeleted{
          comment_uuid: comment_uuid,
          article_uuid: article_uuid,
          author_uuid: author_uuid
        }

      _ ->
        {:error, :only_comment_author_can_delete}
    end
  end

  @doc """
  Stop the comment aggregate after it has been deleted
  """
  def after_event(%CommentDeleted{}), do: :stop
  def after_event(_), do: :timer.hours(1)
  def after_command(_), do: :timer.hours(1)
  def after_error(_), do: :timer.hours(1)

  # state mutators

  def apply(%Comment{} = comment, %ArticleCommented{} = commented) do
    %Comment{
      comment
      | uuid: commented.comment_uuid,
        body: commented.body,
        article_uuid: commented.article_uuid,
        author_uuid: commented.author_uuid
    }
  end

  def apply(%Comment{} = comment, %CommentDeleted{}) do
    %Comment{comment | deleted?: true}
  end
end
