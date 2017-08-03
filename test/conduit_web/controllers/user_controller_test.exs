defmodule ConduitWeb.UserControllerTest do
  use ConduitWeb.ConnCase

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "register user" do
    @tag :web
    test "should create and return user when data is valid", %{conn: conn} do
      conn = post conn, user_path(conn, :create), user: build(:user)
      json = json_response(conn, 201)["user"]
      token = json["token"]

      assert json == %{
        "bio" => nil,
        "email" => "jake@jake.jake",
        "token" => token,
        "image" => nil,
        "username" => "jake",
      }
      refute token == ""
    end

    @tag :web
    test "should not create user and render errors when data is invalid", %{conn: conn} do
      conn = post conn, user_path(conn, :create), user: build(:user, username: "")
      assert json_response(conn, 422)["errors"] == %{
        "username" => [
          "can't be empty",
        ]
      }
    end

    @tag :web
    test "should not create user and render errors when username has been taken", %{conn: conn} do
      # register a user
      {:ok, _user} = fixture(:user)

      # attempt to register the same username
      conn = post conn, user_path(conn, :create), user: build(:user, email: "jake2@jake.jake")
      assert json_response(conn, 422)["errors"] == %{
        "username" => [
          "has already been taken",
        ]
      }
    end
  end

  describe "get current user" do
    @tag :web
    test "should return user when authenticated", %{conn: conn} do
      conn = get authenticated_conn(conn), user_path(conn, :current)
      json = json_response(conn, 200)["user"]
      token = json["token"]

      assert json == %{
        "bio" => nil,
        "email" => "jake@jake.jake",
        "token" => token,
        "image" => nil,
        "username" => "jake",
      }
      refute token == ""
    end

    @tag :web
    test "should not return user when unauthenticated", %{conn: conn} do
      conn = get conn, user_path(conn, :current)

      assert response(conn, 401) == ""
    end
  end

  describe "update user" do
    setup [
      :register_user,
      :get_author,
    ]

    @tag :web
    test "should update and return user when data is valid", %{conn: conn, user: user} do
      conn = put authenticated_conn(conn, user), user_path(conn, :update), user: [username: "jakeupdated", email: "jakeupdated@jake.jake"]
      json = json_response(conn, 200)["user"]
      token = json["token"]

      assert json == %{
        "bio" => nil,
        "email" => "jakeupdated@jake.jake",
        "token" => token,
        "image" => nil,
        "username" => "jakeupdated",
      }
      refute token == ""
    end
  end
end
