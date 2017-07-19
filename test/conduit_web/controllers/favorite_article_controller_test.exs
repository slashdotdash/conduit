defmodule ConduitWeb.FavoriteArticleControllerTest do
  use ConduitWeb.ConnCase

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "favorite article" do
    setup [
      :create_author,
      :publish_article,
      :register_user,
    ]

    @tag :web
    test "should be favorited and return article", %{conn: conn, user: user} do
      conn = post authenticated_conn(conn, user), favorite_article_path(conn, :create, "how-to-train-your-dragon")
      json = json_response(conn, 201)["article"]
      created_at = json["createdAt"]
      updated_at = json["updatedAt"]

      assert json == %{
        "slug" => "how-to-train-your-dragon",
        "title" => "How to train your dragon",
        "description" => "Ever wonder how?",
        "body" => "You have to believe",
        "tagList" => ["dragons", "training"],
        "createdAt" => created_at,
        "updatedAt" => updated_at,
        "favorited" => true,
        "favoritesCount" => 1,
        "author" => %{
          "username" => "jake",
          "bio" => nil,
          "image" => nil,
          "following" => false,
        }
      }
    end
  end

  describe "unfavorite article" do
    setup [
      :create_author,
      :publish_article,
      :register_user,
      :get_author,
      :favorite_article,
    ]

    @tag :web
    test "should be unfavorited and return article", %{conn: conn, user: user} do
      conn = delete authenticated_conn(conn, user), favorite_article_path(conn, :delete, "how-to-train-your-dragon")
      json = json_response(conn, 201)["article"]
      created_at = json["createdAt"]
      updated_at = json["updatedAt"]

      assert json == %{
        "slug" => "how-to-train-your-dragon",
        "title" => "How to train your dragon",
        "description" => "Ever wonder how?",
        "body" => "You have to believe",
        "tagList" => ["dragons", "training"],
        "createdAt" => created_at,
        "updatedAt" => updated_at,
        "favorited" => false,
        "favoritesCount" => 0,
        "author" => %{
          "username" => "jake",
          "bio" => nil,
          "image" => nil,
          "following" => false,
        }
      }
    end
  end
end
