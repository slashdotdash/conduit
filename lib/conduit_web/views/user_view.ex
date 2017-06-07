defmodule ConduitWeb.UserView do
  use ConduitWeb, :view
  alias ConduitWeb.UserView

  def render("index.json", %{users: users}) do
    %{data: render_many(users, UserView, "user.json")}
  end

  def render("show.json", %{user: user}) do
    %{data: render_one(user, UserView, "user.json")}
  end

  def render("user.json", %{user: user}) do
    %{id: user.id,
      username: user.username,
      email: user.email,
      hashed_password: user.hashed_password,
      bio: user.bio,
      image: user.image}
  end
end
