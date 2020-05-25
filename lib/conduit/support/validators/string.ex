defmodule Conduit.Support.Validators.String do
  use Vex.Validator

  def validate(nil, _options), do: :ok
  def validate("", _options), do: :ok

  def validate(value, _options) do
    Vex.Validators.By.validate(value, function: &String.valid?/1)
  end
end
