defmodule ConduitWeb.SessionControllerTest do
  use ConduitWeb.ConnCase

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "authenticate user" do
    @tag :web
    test "creates session and renders session when data is valid", %{conn: conn} do
      register_user()

      conn = post conn, session_path(conn, :create), user: %{
        email: "jake@jake.jake",
        password: "jakejake"
      }

      assert json_response(conn, 201)["user"] == %{
        "bio" => nil,
        "email" =>
        "jake@jake.jake",
        "image" => nil,
        "username" => "jake",
      }
    end

    @tag :web
    test "does not create session and renders errors when password does not match", %{conn: conn} do
      register_user()

      conn = post conn, session_path(conn, :create), user: %{
        email: "jake@jake.jake",
        password: "invalidpassword"
      }

      assert json_response(conn, 422)["errors"] == %{
        "email or password" => [
          "is invalid"
        ]
      }
    end

    @tag :web
    test "does not create session and renders errors when user not found", %{conn: conn} do
      conn = post conn, session_path(conn, :create), user: %{
        email: "doesnotexist",
        password: "jakejake"
      }

      assert json_response(conn, 422)["errors"] == %{
        "email or password" => [
          "is invalid"
        ]
      }
    end
  end

  defp register_user, do: fixture(:user)
end
