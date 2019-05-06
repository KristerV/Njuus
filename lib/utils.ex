defmodule Utils do
  def typeof(val) do
    cond do
      is_float(val) -> "float"
      is_number(val) -> "number"
      is_atom(val) -> "atom"
      is_boolean(val) -> "boolean"
      is_binary(val) -> "binary"
      is_function(val) -> "function"
      is_list(val) -> "list"
      is_tuple(val) -> "tuple"
      true -> "not sure"
    end
  end

  def parseDate(str) do
    str
    |> String.replace("GMT", "+0000")
    |> Timex.parse!("{RFC1123}")
  end
end
