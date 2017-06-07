defmodule ConduitWeb.UserControllerTest do
  use ConduitWeb.ConnCase

  alias Conduit.Accounts
  alias Conduit.Accounts.User

  @create_attrs %{bio: "some bio", email: "some email", hashed_password: "some hashed_password", image: "some image", username: "some username"}
  @update_attrs %{bio: "some updated bio", email: "some updated email", hashed_password: "some updated hashed_password", image: "some updated image", username: "some updated username"}
  @invalid_attrs %{bio: nil, email: nil, hashed_password: nil, image: nil, username: nil}

  def fixture(:user) do
    {:ok, user} = Accounts.create_user(@create_attrs)
    user
  end

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  test "lists all entries on index", %{conn: conn} do
    conn = get conn, user_path(conn, :index)
    assert json_response(conn, 200)["data"] == []
  end

  test "creates user and renders user when data is valid", %{conn: conn} do
    conn = post conn, user_path(conn, :create), user: @create_attrs
    assert %{"id" => id} = json_response(conn, 201)["data"]

    conn = get conn, user_path(conn, :show, id)
    assert json_response(conn, 200)["data"] == %{
      "id" => id,
      "bio" => "some bio",
      "email" => "some email",
      "hashed_password" => "some hashed_password",
      "image" => "some image",
      "username" => "some username"}
  end

  test "does not create user and renders errors when data is invalid", %{conn: conn} do
    conn = post conn, user_path(conn, :create), user: @invalid_attrs
    assert json_response(conn, 422)["errors"] != %{}
  end

  test "updates chosen user and renders user when data is valid", %{conn: conn} do
    %User{id: id} = user = fixture(:user)
    conn = put conn, user_path(conn, :update, user), user: @update_attrs
    assert %{"id" => ^id} = json_response(conn, 200)["data"]

    conn = get conn, user_path(conn, :show, id)
    assert json_response(conn, 200)["data"] == %{
      "id" => id,
      "bio" => "some updated bio",
      "email" => "some updated email",
      "hashed_password" => "some updated hashed_password",
      "image" => "some updated image",
      "username" => "some updated username"}
  end

  test "does not update chosen user and renders errors when data is invalid", %{conn: conn} do
    user = fixture(:user)
    conn = put conn, user_path(conn, :update, user), user: @invalid_attrs
    assert json_response(conn, 422)["errors"] != %{}
  end

  test "deletes chosen user", %{conn: conn} do
    user = fixture(:user)
    conn = delete conn, user_path(conn, :delete, user)
    assert response(conn, 204)
    assert_error_sent 404, fn ->
      get conn, user_path(conn, :show, user)
    end
  end
end
