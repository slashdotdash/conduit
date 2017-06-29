defmodule Conduit.Router do
  use Commanded.Commands.Router

  alias Conduit.Accounts.Aggregates.User
  alias Conduit.Accounts.Commands.RegisterUser
  alias Conduit.Blog.Aggregates.{Article,Author}
  alias Conduit.Blog.Commands.{CreateAuthor,PublishArticle}
  alias Conduit.Support.Middleware.{Uniqueness,Validate}

  middleware Validate
  middleware Uniqueness

  identify Article, by: :article_uuid, prefix: "article-"
  identify Author, by: :author_uuid, prefix: "author-"
  identify User, by: :user_uuid, prefix: "user-"

  dispatch [PublishArticle], to: Article
  dispatch [CreateAuthor], to: Author
  dispatch [RegisterUser], to: User
end
