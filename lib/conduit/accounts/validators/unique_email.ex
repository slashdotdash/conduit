defmodule Conduit.Accounts.Validators.UniqueEmail do
  use Vex.Validator

  alias Conduit.Accounts

  def validate(value, _options) do
    Vex.Validators.By.validate(value, [
      function: fn value -> !email_registered?(value) end,
      message: "has already been taken"
    ])
  end

  defp email_registered?(email) do
    case Accounts.user_by_email(email) do
      nil -> false
      _ -> true
    end
  end
end
