defmodule Conduit.Blog.ArticleTest do
  use Conduit.AggregateCase, aggregate: Conduit.Blog.Aggregates.Article

  alias Conduit.Blog.Commands.{
    FavoriteArticle,
    UnfavoriteArticle,
  }

  alias Conduit.Blog.Events.{
    ArticleFavorited,
    ArticlePublished,
    ArticleUnfavorited,
  }

  describe "publish article" do
    @tag :unit
    test "should succeed when valid" do
      article_uuid = UUID.uuid4()
      author_uuid = UUID.uuid4()

      assert_events build(:publish_article, article_uuid: article_uuid, author_uuid: author_uuid), [
        %ArticlePublished{
          article_uuid: article_uuid,
          slug: "how-to-train-your-dragon",
          title: "How to train your dragon",
          description: "Ever wonder how?",
          body: "You have to believe",
          tags: ["dragons", "training"],
          author_uuid: author_uuid,
        },
      ]
    end
  end

  describe "favorite article" do
    setup [
      :publish_article,
    ]

    @tag :unit
    test "should succeed when not already a favorite", %{article: article} do
      author_uuid = UUID.uuid4()

      assert_events article, %FavoriteArticle{article_uuid: article.uuid, favorited_by_author_uuid: author_uuid}, [
        %ArticleFavorited{
          article_uuid: article.uuid,
          favorited_by_author_uuid: author_uuid,
          favorite_count: 1,
        },
      ]
    end

    @tag :unit
    test "should ignore when already a favorite", %{article: article} do
      author_uuid = UUID.uuid4()

      assert_events article, [
        %FavoriteArticle{article_uuid: article.uuid, favorited_by_author_uuid: author_uuid},
        %FavoriteArticle{article_uuid: article.uuid, favorited_by_author_uuid: author_uuid}
      ], []
    end
  end

  describe "unfavorite article" do
    setup [
      :publish_article,
    ]

    @tag :unit
    test "should succeed when a favorite", %{article: article} do
      author_uuid = UUID.uuid4()

      assert_events article, [
        %FavoriteArticle{article_uuid: article.uuid, favorited_by_author_uuid: author_uuid},
        %UnfavoriteArticle{article_uuid: article.uuid, unfavorited_by_author_uuid: author_uuid},
      ], [
        %ArticleUnfavorited{
          article_uuid: article.uuid,
          unfavorited_by_author_uuid: author_uuid,
          favorite_count: 0,
        },
      ]
    end

    @tag :unit
    test "should ignore when not a favorite", %{article: article} do
      author_uuid = UUID.uuid4()

      assert_events article, [
        %UnfavoriteArticle{article_uuid: article.uuid, unfavorited_by_author_uuid: author_uuid},
      ], []
    end
  end

  defp publish_article(_context) do
    article_uuid = UUID.uuid4()
    author_uuid = UUID.uuid4()

    {article, _events} = execute(build(:publish_article, article_uuid: article_uuid, author_uuid: author_uuid))

    [
      article: article,
    ]
  end
end
