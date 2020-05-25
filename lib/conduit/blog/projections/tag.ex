defmodule Conduit.Blog.Projections.Tag do
  use Ecto.Schema

  @primary_key {:uuid, :binary_id, autogenerate: true}
  @timestamps_opts [type: :utc_datetime_usec]

  schema "blog_tags" do
    field(:name, :string)

    timestamps()
  end
end
