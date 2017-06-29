defmodule ConduitWeb.ArticleView do
  use ConduitWeb, :view
  alias ConduitWeb.ArticleView

  def render("index.json", %{articles: articles}) do
    %{data: render_many(articles, ArticleView, "article.json")}
  end

  def render("show.json", %{article: article}) do
    %{data: render_one(article, ArticleView, "article.json")}
  end

  def render("article.json", %{article: article}) do
    %{id: article.id,
      slug: article.slug,
      title: article.title,
      description: article.description,
      body: article.body,
      tag_list: article.tag_list,
      favorite_count: article.favorite_count,
      author_uuid: article.author_uuid,
      author_username: article.author_username,
      author_bio: article.author_bio,
      author_image: article.author_image}
  end
end
