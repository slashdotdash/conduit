defmodule ConduitWeb.ProfileControllerTest do
  use ConduitWeb.ConnCase

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "get profile" do
    setup [
      :create_author,
    ]

    @tag :web
    test "should return author profile", %{conn: conn} do
      conn = get conn, profile_path(conn, :show, "jake")
      json = json_response(conn, 200)

      assert json == %{
        "profile" => %{
          "username" => "jake",
          "bio" => nil,
          "image" => nil,
          "following" => false,
        }
      }
    end
  end
end
