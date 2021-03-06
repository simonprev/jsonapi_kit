defmodule Solage.DataTransform.Utils do
  @moduledoc """
  Takes the decode_formatter and encode_formatter from the application’s config
  and exposes functions to decode and encode a string.
  """

  @decode_formatter Application.get_env(:solage, :decode_formatter, :dasherized)
  @encode_formatter Application.get_env(:solage, :encode_formatter, :dasherized)

  def decode_key(key), do: process(key, @decode_formatter, :decode_key)
  def encode_key(key), do: process(key, @encode_formatter, :encode_key)

  defp process(key, formatter, function) do
    case formatter do
      :dasherized -> apply(Solage.DataTransform.Dasherized, function, [key])
      module when is_atom(module) -> apply(module, function, [key])
      _ -> key
    end
  end
end
