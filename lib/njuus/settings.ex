defmodule Filters do
  defstruct category: [], provider: []
end

defmodule Njuus.Settings do
  @enforce_keys [:filters]
  defstruct filters: %Filters{}

  def new do
    %Njuus.Settings{filters: %Filters{}}
  end
end
