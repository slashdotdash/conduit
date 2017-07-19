defmodule Conduit.BlogTest do
  use Conduit.DataCase

  alias Conduit.Blog
  alias Conduit.Blog.Projections.Article

  describe "publish article" do
    setup [
      :create_author,
    ]

    @tag :integration
    test "should succeed with valid data", %{author: author} do
      assert {:ok, %Article{} = article} = Blog.publish_article(author, build(:article))

      assert article.slug == "how-to-train-your-dragon"
      assert article.title == "How to train your dragon"
      assert article.description == "Ever wonder how?"
      assert article.body == "You have to believe"
      assert article.tag_list == ["dragons", "training"]
      assert article.author_username == "jake"
      assert article.author_bio == nil
      assert article.author_image == nil
    end

    @tag :integration
    test "should generate unique URL slug", %{author: author} do
      assert {:ok, %Article{} = article1} = Blog.publish_article(author, build(:article))
      assert article1.slug == "how-to-train-your-dragon"

      assert {:ok, %Article{} = article2} = Blog.publish_article(author, build(:article))
      assert article2.slug == "how-to-train-your-dragon-2"
    end
  end

  describe "list articles" do
    setup [
      :create_author,
      :publish_articles,
    ]

    @tag :integration
    test "should list articles by published date", %{articles: [article1, article2]} do
      assert {[article2, article1], 2} == Blog.list_articles()
    end

    @tag :integration
    test "should limit articles", %{articles: [_article1, article2]} do
      assert {[article2], 2} == Blog.list_articles(%{limit: 1})
    end

    @tag :integration
    test "should paginate articles", %{articles: [article1, _article2]} do
      assert {[article1], 2} == Blog.list_articles(%{offset: 1})
    end

    @tag :integration
    test "should filter by author" do
      assert {[], 0} == Blog.list_articles(%{author: "unknown"})
    end

    @tag :integration
    test "should filter by author returning only their articles", %{articles: [article1, article2]} do
      assert {[article2, article1], 2} == Blog.list_articles(%{author: "jake"})
    end

    @tag :integration
    test "should filter by tag returning only tagged articles", %{articles: [article1, _article2]} do
      assert {[article1], 1} == Blog.list_articles(%{tag: "believe"})
    end

    @tag :integration
    test "should filter by tag" do
      assert {[], 0} == Blog.list_articles(%{tag: "unknown"})
    end
  end

  describe "list articles favorited by user" do
    setup [
      :create_author,
      :publish_articles,
      :favorite_article,
    ]

    @tag :integration
    test "should filter by favorited by user", %{articles: [article1, _article2]} do
      {articles, total_count} = Blog.list_articles(%{favorited: "jake"})

      assert articles == [%Article{article1 | favorited: false}]
      assert total_count == 1
    end

    @tag :integration
    test "should filter by favorited by user without favorites" do
      assert {[], 0} == Blog.list_articles(%{favorited: "anotheruser"})
    end
  end
end
