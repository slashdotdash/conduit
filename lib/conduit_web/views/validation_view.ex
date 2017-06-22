defmodule ConduitWeb.ValidationView do
  use ConduitWeb, :view

  def render("error.json", %{errors: errors}) do
    %{errors: errors}
  end
end
