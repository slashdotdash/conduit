defmodule Conduit.Router do
  use Commanded.Commands.Router

  alias Conduit.Accounts.Aggregates.User
  alias Conduit.Accounts.Commands.RegisterUser
  alias Conduit.Blog.Aggregates.{Article,Author,Comment}
  alias Conduit.Blog.Commands.{
    CreateAuthor,
    CommentOnArticle,
    FavoriteArticle,
    PublishArticle,
    UnfavoriteArticle,
  }
  alias Conduit.Support.Middleware.{Uniqueness,Validate}

  middleware Validate
  middleware Uniqueness

  identify Article, by: :article_uuid, prefix: "article-"
  identify Author, by: :author_uuid, prefix: "author-"
  identify Comment, by: :comment_uuid, prefix: "comment-"
  identify User, by: :user_uuid, prefix: "user-"

  dispatch [
    PublishArticle,
    FavoriteArticle,
    UnfavoriteArticle
  ], to: Article

  dispatch [CreateAuthor], to: Author

  dispatch [CommentOnArticle], to: Comment
  
  dispatch [RegisterUser], to: User
end
