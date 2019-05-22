defmodule Njuus.Core.Categories do
  @moduledoc """
  Converts RSS feed categories to our own system.
  """
  alias Njuus.Feeds

  @pairs Application.get_env(:njuus, Njuus.Core.Categories)[:pairs]

  def categorize_posts(posts) do
    posts
    |> Enum.map(fn post -> Map.put(post, :category, find_category(post)) end)
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
    feed = Feeds.get_feed_map()

    Enum.find_value(post.categories, fn cat ->
      inverse_keys()[cat]
    end) || feed[post.provider].category
  end

  def has_category?(post) do
    !!Enum.find_value(post.categories, fn cat ->
      inverse_keys()[cat]
    end)
  end

  def reverse_summarization(cat_list) do
    Enum.reduce(cat_list, [], fn item, acc -> acc ++ @pairs[item] end)
  end
end
