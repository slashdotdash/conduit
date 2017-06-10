defmodule Conduit.Factory do
  use ExMachina

  alias Conduit.Accounts.Commands.RegisterUser

  def user_factory do
    %{
      email: "jake@jake.jake",
      username: "jake",
      password: "jakejake",
      hashed_password: "jakejake",
      bio: "I like to skateboard",
      image: "https://i.stack.imgur.com/xHWG8.jpg",
    }
  end

  def register_user_factory do
    struct(RegisterUser, build(:user))
  end
end
