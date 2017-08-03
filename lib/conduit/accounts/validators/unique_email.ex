defmodule Conduit.Accounts.Validators.UniqueEmail do
  use Vex.Validator

  alias Conduit.Accounts
  alias Conduit.Accounts.Projections.User

  def validate(value, context) do
    user_uuid = Map.get(context, :user_uuid)

    case email_registered?(value, user_uuid) do
      true -> {:error, "has already been taken"}
      false -> :ok
    end
  end

  defp email_registered?(email, user_uuid) do
    case Accounts.user_by_email(email) do
      %User{uuid: ^user_uuid} -> false
      nil -> false
      _ -> true
    end
  end
end
