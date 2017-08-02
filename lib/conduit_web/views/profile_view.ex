defmodule ConduitWeb.ProfileView do
  use ConduitWeb, :view
  alias ConduitWeb.ProfileView

  def render("show.json", %{author: author}) do
    %{profile: render_one(author, ProfileView, "profile.json")}
  end

  def render("profile.json", %{profile: profile}) do
    %{
      username: profile.username,
      bio: profile.bio,
      image: profile.image,
      following: false,
    }
  end
end
