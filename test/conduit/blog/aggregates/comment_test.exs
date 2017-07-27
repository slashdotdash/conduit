defmodule Conduit.Blog.CommentTest do
  use Conduit.AggregateCase, aggregate: Conduit.Blog.Aggregates.Comment

  alias Conduit.Blog.Commands.{
    DeleteComment,
  }

  alias Conduit.Blog.Events.{
    ArticleCommented,
    CommentDeleted,
  }

  describe "comment on article" do
    @tag :unit
    test "should succeed when valid" do
      comment_uuid = UUID.uuid4()
      article_uuid = UUID.uuid4()
      author_uuid = UUID.uuid4()

      assert_events build(:comment_on_article, comment_uuid: comment_uuid, article_uuid: article_uuid, author_uuid: author_uuid), [
        %ArticleCommented{
          comment_uuid: comment_uuid,
          body: "It takes a Jacobian",
          article_uuid: article_uuid,
          author_uuid: author_uuid,
        },
      ]
    end
  end

  describe "delete comment" do
    @tag :unit
    test "should succeed when deleted by comment author" do
      comment_uuid = UUID.uuid4()
      article_uuid = UUID.uuid4()
      user_uuid = UUID.uuid4()

      assert_events [
        build(:comment_on_article, comment_uuid: comment_uuid, article_uuid: article_uuid, author_uuid: user_uuid),
        %DeleteComment{comment_uuid: comment_uuid, deleted_by_author_uuid: user_uuid},
      ], [
        %CommentDeleted{
          comment_uuid: comment_uuid,
          article_uuid: article_uuid,
          author_uuid: user_uuid,
        },
      ]
    end

    @tag :unit
    test "should fail when delete attempted by another user" do
      comment_uuid = UUID.uuid4()
      article_uuid = UUID.uuid4()
      author_uuid = UUID.uuid4()
      deleted_by_author_uuid = UUID.uuid4()

      assert_error [
        build(:comment_on_article, comment_uuid: comment_uuid, article_uuid: article_uuid, author_uuid: author_uuid),
        %DeleteComment{comment_uuid: comment_uuid, deleted_by_author_uuid: deleted_by_author_uuid},
      ], {:error, :only_comment_author_can_delete}
    end
  end
end
