defmodule ConduitWeb.CommentView do
  use ConduitWeb, :view
  alias ConduitWeb.CommentView

  def render("index.json", %{comments: comments}) do
    %{
      comments: render_many(comments, CommentView, "comment.json"),
    }
  end

  def render("show.json", %{comment: comment}) do
    %{comment: render_one(comment, CommentView, "comment.json")}
  end

  def render("comment.json", %{comment: comment}) do
    %{
      id: comment.uuid,
      body: comment.body,
      createdAt: NaiveDateTime.to_iso8601(comment.commented_at),
      updatedAt: NaiveDateTime.to_iso8601(comment.commented_at),
      author: %{
        username: comment.author_username,
        bio: comment.author_bio,
        image: comment.author_image,
        following: false,
      },
    }
  end
end
