defmodule Conduit.Support.Validators.Uuid do
  use Vex.Validator

  def validate(value, options) do
    options = if Keyword.keyword?(options) do
      Keyword.merge([function: &valid_uuid?/1], options)
    else
      [function: &valid_uuid?/1, allow_nil: false, allow_blank: false]
    end
    Vex.Validators.By.validate(value, options)
  end

  defp valid_uuid?(uuid) do
    case UUID.info(uuid) do
      {:ok, _} -> true
      {:error, _} -> false
    end
  end
end
