defprotocol JsonapiKit.DataTransform do
  @fallback_to_any true
  def decode(data)
  def encode(data)
end

defimpl JsonapiKit.DataTransform, for: Any do
  @moduledoc """
  For every use cases not implemented, do nothing.
  """

  def decode(data), do: data
  def encode(data), do: data
end

defimpl JsonapiKit.DataTransform, for: List do
  @moduledoc """
  For every item in the list, run the transform operation.
  """

  def decode(list), do: Enum.map(list, &JsonapiKit.DataTransform.decode/1)
  def encode(list), do: Enum.map(list, &JsonapiKit.DataTransform.encode/1)
end

defimpl JsonapiKit.DataTransform, for: Map do
  @moduledoc """
  For every item in the map, apply transform on the key and run the transform operation on the value.
  """

  def decode(map) do
    process(map, &JsonapiKit.DataTransform.Utils.decode_key/1, &JsonapiKit.DataTransform.decode/1)
  end

  def encode(map) do
    process(map, &JsonapiKit.DataTransform.Utils.encode_key/1, &JsonapiKit.DataTransform.encode/1)
  end

  defp process(map, key_formatter, transform) do
    Enum.reduce map, %{}, fn({key, val}, map) ->
      key = key_formatter.(key)

      Map.put(map, key, transform.(val))
    end
  end
end
