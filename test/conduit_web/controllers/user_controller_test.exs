defmodule ConduitWeb.UserControllerTest do
  use ConduitWeb.ConnCase

  import Conduit.Factory

  alias Conduit.Accounts

  def fixture(:user, attrs \\ []) do
    build(:user, attrs) |> Accounts.register_user()
  end

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "register user" do
    test "should create and return user when data is valid", %{conn: conn} do
      conn = post conn, user_path(conn, :create), user: build(:user)
      json = json_response(conn, 201)["user"]

      assert json == build(:user, bio: nil, image: nil)
    end

    test "should not create user and render errors when data is invalid", %{conn: conn} do
      conn = post conn, user_path(conn, :create), user: build(:user, username: nil)
      assert json_response(conn, 422)["errors"] == [
        username: [
          "can't be empty",
        ]
      ]
    end

    test "should not create user and render errors when username has been taken", %{conn: conn} do
      # register a user
      {:ok, _user} = fixture(:user)

      # attempt to register the same username
      conn = post conn, user_path(conn, :create), user: build(:user)
      assert json_response(conn, 422)["errors"] == [
        username: [
          "has already been taken",
        ]
      ]
    end
  end
end
