defmodule ConduitWeb.ArticleControllerTest do
  use ConduitWeb.ConnCase

  alias Conduit.Blog
  alias Conduit.Blog.Projections.Article

  @create_attrs %{author_bio: "some author_bio", author_image: "some author_image", author_username: "some author_username", author_uuid: "7488a646-e31f-11e4-aace-600308960662", body: "some body", description: "some description", favorite_count: 42, slug: "some slug", tag_list: [], title: "some title"}
  @update_attrs %{author_bio: "some updated author_bio", author_image: "some updated author_image", author_username: "some updated author_username", author_uuid: "7488a646-e31f-11e4-aace-600308960668", body: "some updated body", description: "some updated description", favorite_count: 43, slug: "some updated slug", tag_list: [], title: "some updated title"}
  @invalid_attrs %{author_bio: nil, author_image: nil, author_username: nil, author_uuid: nil, body: nil, description: nil, favorite_count: nil, slug: nil, tag_list: nil, title: nil}

  def fixture(:article) do
    {:ok, article} = Blog.create_article(@create_attrs)
    article
  end

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  test "lists all entries on index", %{conn: conn} do
    conn = get conn, article_path(conn, :index)
    assert json_response(conn, 200)["data"] == []
  end

  test "creates article and renders article when data is valid", %{conn: conn} do
    conn = post conn, article_path(conn, :create), article: @create_attrs
    assert %{"id" => id} = json_response(conn, 201)["data"]

    conn = get conn, article_path(conn, :show, id)
    assert json_response(conn, 200)["data"] == %{
      "id" => id,
      "author_bio" => "some author_bio",
      "author_image" => "some author_image",
      "author_username" => "some author_username",
      "author_uuid" => "7488a646-e31f-11e4-aace-600308960662",
      "body" => "some body",
      "description" => "some description",
      "favorite_count" => 42,
      "slug" => "some slug",
      "tag_list" => [],
      "title" => "some title"}
  end

  test "does not create article and renders errors when data is invalid", %{conn: conn} do
    conn = post conn, article_path(conn, :create), article: @invalid_attrs
    assert json_response(conn, 422)["errors"] != %{}
  end

  test "updates chosen article and renders article when data is valid", %{conn: conn} do
    %Article{id: id} = article = fixture(:article)
    conn = put conn, article_path(conn, :update, article), article: @update_attrs
    assert %{"id" => ^id} = json_response(conn, 200)["data"]

    conn = get conn, article_path(conn, :show, id)
    assert json_response(conn, 200)["data"] == %{
      "id" => id,
      "author_bio" => "some updated author_bio",
      "author_image" => "some updated author_image",
      "author_username" => "some updated author_username",
      "author_uuid" => "7488a646-e31f-11e4-aace-600308960668",
      "body" => "some updated body",
      "description" => "some updated description",
      "favorite_count" => 43,
      "slug" => "some updated slug",
      "tag_list" => [],
      "title" => "some updated title"}
  end

  test "does not update chosen article and renders errors when data is invalid", %{conn: conn} do
    article = fixture(:article)
    conn = put conn, article_path(conn, :update, article), article: @invalid_attrs
    assert json_response(conn, 422)["errors"] != %{}
  end

  test "deletes chosen article", %{conn: conn} do
    article = fixture(:article)
    conn = delete conn, article_path(conn, :delete, article)
    assert response(conn, 204)
    assert_error_sent 404, fn ->
      get conn, article_path(conn, :show, article)
    end
  end
end
