defmodule Conduit.Blog.Commands.PublishArticle do
  defstruct [
    article_uuid: "",
    author_uuid: "",
    slug: "",
    title: "",
    description: "",
    body: "",
    tag_list: [],
  ]

  use ExConstructor
  use Vex.Struct

  alias Conduit.Blog.Projections.Author
  alias Conduit.Blog.Slugger
  alias Conduit.Blog.Commands.PublishArticle

  validates :article_uuid, uuid: true

  validates :author_uuid, uuid: true

  validates :slug,
    presence: [message: "can't be empty"],
    format: [with: ~r/^[a-z0-9\-]+$/, allow_nil: true, allow_blank: true, message: "is invalid"],
    string: true,
    unique_article_slug: true

  validates :title, presence: [message: "can't be empty"], string: true

  validates :description, presence: [message: "can't be empty"], string: true

  validates :body, presence: [message: "can't be empty"], string: true

  validates :tag_list, by: &is_list/1

  @doc """
  Assign a unique identity
  """
  def assign_uuid(%PublishArticle{} = publish_article, uuid) do
    %PublishArticle{publish_article | article_uuid: uuid}
  end

  @doc """
  Assign the author
  """
  def assign_author(%PublishArticle{} = publish_article, %Author{uuid: uuid}) do
    %PublishArticle{publish_article | author_uuid: uuid}
  end

  @doc """
  Generate a unique URL slug from the article title
  """
  def generate_url_slug(%PublishArticle{title: title} = publish_article) do
    case Slugger.slugify(title) do
      {:ok, slug} -> %PublishArticle{publish_article | slug: slug}
      _ -> publish_article
    end
  end
end

defimpl Conduit.Support.Middleware.Uniqueness.UniqueFields, for: Conduit.Blog.Commands.PublishArticle do
  def unique(%Conduit.Blog.Commands.PublishArticle{article_uuid: article_uuid}), do: [
    {:slug, "has already been taken", article_uuid},
  ]
end
