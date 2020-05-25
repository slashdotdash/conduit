defmodule ConduitWeb.ProfileControllerTest do
  use ConduitWeb.ConnCase

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "get profile" do
    setup [
      :create_author
    ]

    @tag :web
    test "should return author profile", %{conn: conn} do
      conn = get(conn, profile_path(conn, :show, "jake"))
      json = json_response(conn, 200)

      assert json == %{
               "profile" => %{
                 "username" => "jake",
                 "bio" => nil,
                 "image" => nil,
                 "following" => false
               }
             }
    end
  end

  describe "follow profile" do
    setup [
      :register_user,
      :get_author,
      :create_author_to_follow
    ]

    @tag :web
    test "should follow author", %{conn: conn, user: user} do
      conn = post(authenticated_conn(conn, user), profile_path(conn, :follow, "jane"))
      json = json_response(conn, 201)

      assert json == %{
               "profile" => %{
                 "username" => "jane",
                 "bio" => nil,
                 "image" => nil,
                 "following" => true
               }
             }
    end
  end

  describe "unfollow profile" do
    setup [
      :register_user,
      :get_author,
      :create_author_to_follow,
      :follow_author
    ]

    @tag :web
    test "should follow author", %{conn: conn, user: user} do
      conn = delete(authenticated_conn(conn, user), profile_path(conn, :follow, "jane"))
      json = json_response(conn, 201)

      assert json == %{
               "profile" => %{
                 "username" => "jane",
                 "bio" => nil,
                 "image" => nil,
                 "following" => false
               }
             }
    end
  end

  describe "get followed author profile" do
    setup [
      :register_user,
      :get_author,
      :create_author_to_follow,
      :follow_author
    ]

    @tag :web
    test "should return author profile", %{conn: conn, user: user} do
      conn = get(authenticated_conn(conn, user), profile_path(conn, :show, "jane"))
      json = json_response(conn, 200)

      assert json == %{
               "profile" => %{
                 "username" => "jane",
                 "bio" => nil,
                 "image" => nil,
                 "following" => true
               }
             }
    end
  end
end
