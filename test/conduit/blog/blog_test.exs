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
      assert article.tags == ["dragons", "training"]
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
  end

  defp create_author(_context) do
    {:ok, author} = fixture(:author, user_uuid: UUID.uuid4())

    [
      author: author,
    ]
  end

  defp publish_articles(%{author: author}) do
    {:ok, article1} = fixture(:article, author: author)
    {:ok, article2} =fixture(:article, author: author, title: "How to train your dragon 2", description: "So toothless", body: "It a dragon")

    [
      articles: [article1, article2],
    ]
  end
end
