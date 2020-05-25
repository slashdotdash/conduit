defmodule Conduit.Support.Validators.Uuid do
  use Vex.Validator

  def validate(value, _options) do
    Vex.Validators.By.validate(value,
      function: &valid_uuid?/1,
      allow_nil: false,
      allow_blank: false
    )
  end

  defp valid_uuid?(uuid) do
    case UUID.info(uuid) do
      {:ok, _} -> true
      {:error, _} -> false
    end
  end
end
