defmodule Conduit.Factory do
  use ExMachina

  alias Conduit.Accounts.Commands.RegisterUser
  alias Conduit.Blog.Commands.{
    CommentOnArticle,
    PublishArticle,
  }

  def article_factory do
    %{
      slug: "how-to-train-your-dragon",
      title: "How to train your dragon",
      description: "Ever wonder how?",
      body: "You have to believe",
      tag_list: ["dragons", "training"],
      author_uuid: UUID.uuid4(),
    }
  end

  def author_factory do
    %{
      user_uuid: UUID.uuid4(),
      username: "jake",
      bio: "I like to skateboard",
      image: "https://i.stack.imgur.com/xHWG8.jpg",
    }
  end

  def comment_factory do
    %{
      body: "It takes a Jacobian",
      article_uuid: UUID.uuid4(),
      author_uuid: UUID.uuid4(),
    }
  end

  def user_factory do
    %{
      email: "jake@jake.jake",
      username: "jake",
      password: "jakejake",
      hashed_password: "jakejake",
      bio: "I like to skateboard",
      image: "https://i.stack.imgur.com/xHWG8.jpg",
    }
  end

  def comment_on_article_factory do
    struct(CommentOnArticle, build(:comment))
  end

  def publish_article_factory do
    struct(PublishArticle, build(:article))
  end

  def register_user_factory do
    struct(RegisterUser, build(:user))
  end
end
