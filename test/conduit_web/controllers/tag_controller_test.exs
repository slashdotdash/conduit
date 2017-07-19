defmodule ConduitWeb.TagControllerTest do
  use ConduitWeb.ConnCase

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "list tags" do
    setup [
      :create_author,
      :publish_article,
    ]

    @tag :web
    test "should return all tags", %{conn: conn} do
      conn = get conn, tag_path(conn, :index)
      json = json_response(conn, 200)

      assert json == %{
        "tags" => [
          "dragons",
          "training",
        ]
      }
    end
  end
end
