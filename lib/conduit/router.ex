defmodule Conduit.Router do
  use Commanded.Commands.Router

  alias Conduit.Accounts.Aggregates.User
  alias Conduit.Accounts.Commands.{
    RegisterUser,
    UpdateUser,
  }
  alias Conduit.Blog.Aggregates.{Article,Author,Comment}
  alias Conduit.Blog.Commands.{
    CreateAuthor,
    CommentOnArticle,
    DeleteComment,
    FavoriteArticle,
    FollowAuthor,
    PublishArticle,
    UnfavoriteArticle,
    UnfollowAuthor,
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

  dispatch [
    CreateAuthor,
    FollowAuthor,
    UnfollowAuthor,
  ], to: Author

  dispatch [
    CommentOnArticle,
    DeleteComment,
  ], to: Comment, lifespan: Comment

  dispatch [
    RegisterUser,
    UpdateUser,
  ], to: User
end
