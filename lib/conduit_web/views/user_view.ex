defmodule ConduitWeb.UserView do
  use ConduitWeb, :view
  alias ConduitWeb.UserView

  def render("index.json", %{users: users}) do
    %{users: render_many(users, UserView, "user.json")}
  end

  def render("show.json", %{user: user, jwt: jwt}) do
    %{user: user |> render_one(UserView, "user.json") |> Map.merge(%{token: jwt})}
  end

  def render("user.json", %{user: user}) do
    %{
      username: user.username,
      email: user.email,
      bio: nil,
      image: nil,
    }
  end
end
