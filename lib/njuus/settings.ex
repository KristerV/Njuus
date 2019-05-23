defmodule Filters do
  # @enforce_keys [:category, :provider]
  defstruct category: [], provider: []

  def from_map(content) do
    struct(Filters, %{
      category: content["category"],
      provider: content["provider"]
    })
  end
end

defmodule Njuus.Settings do
  @enforce_keys [:filters]
  defstruct filters: %Filters{}

  def new do
    %Njuus.Settings{filters: %Filters{}}
  end

  def from_map(content) do
    struct(Njuus.Settings, %{
      filters: Filters.from_map(content["filters"])
    })
  end
end
