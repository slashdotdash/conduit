defmodule Conduit.DataCase do
  use ExUnit.CaseTemplate

  using do
    quote do
      alias Conduit.Repo

      import Ecto
      import Ecto.Changeset
      import Ecto.Query
      import Conduit.Factory
      import Conduit.Fixture      
      import Conduit.DataCase
    end
  end

  setup do
    Conduit.Storage.reset!()

    :ok
  end
end
