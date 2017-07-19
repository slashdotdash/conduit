defmodule ConduitWeb.ArticleView do
  use ConduitWeb, :view
  alias ConduitWeb.ArticleView

  def render("index.json", %{articles: articles, total_count: total_count}) do
    %{
      articles: render_many(articles, ArticleView, "article.json", %{favorited: false}),
      articlesCount: total_count,
    }
  end

  def render("show.json", %{article: article, favorited: favorited}) do
    %{article: render_one(article, ArticleView, "article.json", %{favorited: favorited})}
  end

  def render("article.json", %{article: article, favorited: favorited}) do
    %{
      slug: article.slug,
      title: article.title,
      description: article.description,
      body: article.body,
      tagList: article.tags,
      createdAt: NaiveDateTime.to_iso8601(article.published_at),
      updatedAt: NaiveDateTime.to_iso8601(article.updated_at),
      favoritesCount: article.favorite_count,
      favorited: favorited,
      author: %{
        username: article.author_username,
        bio: article.author_bio,
        image: article.author_image,
        following: false,
      },
    }
  end
end
