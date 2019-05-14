defmodule Njuus.Core.Categories do
  @moduledoc """
  Converts RSS feed categories to our own system.
  """

  @pairs Application.get_env(:njuus, Njuus.Core.Categories)[:pairs]

  def categorize_posts(posts) do
    posts
    |> Enum.map(fn post -> Map.put(post, :category, find_category(post)) end)
    |> IO.inspect()
  end

  def inverse_keys() do
    for(
      {newCat, oldCatList} <- @pairs,
      oldCat <- oldCatList,
      do: {oldCat, newCat}
    )
    |> Map.new()
  end

  def find_category(post) do
    Enum.find_value(post.categories, "muu", fn cat -> inverse_keys()[cat] end)
  end
end
