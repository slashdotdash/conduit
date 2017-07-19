defmodule Conduit.Blog.ArticleTest do
  use Conduit.AggregateCase, aggregate: Conduit.Blog.Aggregates.Article

  alias Conduit.Blog.Commands.{
    FavoriteArticle,
    UnfavoriteArticle
  }

  alias Conduit.Blog.Events.{
    ArticleFavorited,
    ArticleUnfavorited
  }

  describe "publish article" do
    @tag :unit
    test "should succeed when valid" do
      article_uuid = UUID.uuid4()
      author_uuid = UUID.uuid4()

      assert_events(
        build(:publish_article, article_uuid: article_uuid, author_uuid: author_uuid),
        [
          build(:article_published, article_uuid: article_uuid, author_uuid: author_uuid)
        ]
      )
    end
  end

  describe "favorite article" do
    @tag :unit
    test "should succeed when not already a favorite" do
      article_uuid = UUID.uuid4()
      author_uuid = UUID.uuid4()

      assert_events(
        build(:article_published, article_uuid: article_uuid, author_uuid: author_uuid),
        %FavoriteArticle{article_uuid: article_uuid, favorited_by_author_uuid: author_uuid},
        [
          %ArticleFavorited{
            article_uuid: article_uuid,
            favorited_by_author_uuid: author_uuid,
            favorite_count: 1
          }
        ]
      )
    end

    @tag :unit
    test "should ignore when already a favorite" do
      article_uuid = UUID.uuid4()
      author_uuid = UUID.uuid4()

      assert_events(
        build(:article_published, article_uuid: article_uuid, author_uuid: author_uuid),
        [
          %FavoriteArticle{article_uuid: article_uuid, favorited_by_author_uuid: author_uuid},
          %FavoriteArticle{article_uuid: article_uuid, favorited_by_author_uuid: author_uuid}
        ],
        []
      )
    end
  end

  describe "unfavorite article" do
    @tag :unit
    test "should succeed when a favorite" do
      article_uuid = UUID.uuid4()
      author_uuid = UUID.uuid4()

      assert_events(
        build(:article_published, article_uuid: article_uuid, author_uuid: author_uuid),
        [
          %FavoriteArticle{article_uuid: article_uuid, favorited_by_author_uuid: author_uuid},
          %UnfavoriteArticle{article_uuid: article_uuid, unfavorited_by_author_uuid: author_uuid}
        ],
        [
          %ArticleUnfavorited{
            article_uuid: article_uuid,
            unfavorited_by_author_uuid: author_uuid,
            favorite_count: 0
          }
        ]
      )
    end

    @tag :unit
    test "should ignore when not a favorite" do
      article_uuid = UUID.uuid4()
      author_uuid = UUID.uuid4()

      assert_events(
        build(:article_published, article_uuid: article_uuid, author_uuid: author_uuid),
        [
          %UnfavoriteArticle{article_uuid: article_uuid, unfavorited_by_author_uuid: author_uuid}
        ],
        []
      )
    end
  end
end
