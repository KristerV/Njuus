defmodule NjuusWeb.AdminController do
  use NjuusWeb, :controller

  alias Njuus.Core
  alias Njuus.Core.Post
  alias Njuus.Core.Categories

  def index(conn, _params) do
    trackings = Core.list_tracking()

    posts =
      Core.list_posts()
      |> Categories.categorize_posts()

    cat_count =
      Enum.reduce(posts, %{}, fn post, acc -> Map.update(acc, post.category, 1, &(&1 + 1)) end)
      |> (&Enum.sort_by(Map.to_list(&1), fn {key, val} -> -val end)).()

    day_count =
      Enum.reduce(posts, %{}, fn post, acc ->
        Map.update(acc, DateTime.to_date(post.datetime), 1, &(&1 + 1))
      end)
      |> (&Enum.sort_by(Map.to_list(&1), fn {key, val} -> key end, fn d1, d2 ->
            case Date.compare(d1, d2) do
              :lt -> false
              _ -> true
            end
          end)).()
      |> Enum.slice(0..14)

    categories =
      Enum.reduce(posts, %{}, fn post, acc ->
        if !Categories.has_category?(post) do
          catLink =
            post.categories
            |> Enum.map(fn cat -> {cat, post.link} end)

          Map.merge(acc, %{post.provider() => catLink}, fn _k, v1, v2 ->
            Enum.uniq_by(v1 ++ v2, fn {cat, link} -> cat end)
          end)
        else
          acc
        end
      end)

    render(conn, "index.html", %{
      categories: categories,
      trackings: trackings,
      posts: posts,
      cat_count: cat_count,
      day_count: day_count
    })
  end
end
