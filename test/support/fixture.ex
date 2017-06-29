defmodule Conduit.Fixture do
  import Conduit.Factory

  alias Conduit.{Accounts,Blog}

  def fixture(resource, attrs \\ [])

  def fixture(:author, attrs) do
    build(:author, attrs) |> Blog.create_author()
  end

  def fixture(:user, attrs) do
    build(:user, attrs) |> Accounts.register_user()
  end

  def fixture(:article, attrs) do
    {author, attrs} = Keyword.pop(attrs, :author)

    Blog.publish_article(author, build(:article, attrs))
  end
end
