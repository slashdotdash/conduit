defmodule ConduitWeb.TagView do
  use ConduitWeb, :view

  def render("index.json", %{tags: tags}) do
    %{tags: tags}
  end
end
