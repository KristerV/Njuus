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

  @doc """
  Converts category list into provider list by
  matching default provider categories.
  """
  def get_default_providers(cat_list) do
    default_cats = Njuus.Feeds.get_default_categories()

    cat_list
    |> Enum.reduce([], fn cat, acc -> acc ++ (default_cats[cat] || []) end)
  end

  def get_all() do
    Map.keys(@pairs)
  end
end
