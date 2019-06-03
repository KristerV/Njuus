defmodule NjuusWeb.StatsController do
  use NjuusWeb, :controller

  alias Njuus.Core
  alias Njuus.Core.Categories

  def index(conn, _params) do
    trackings = Core.list_tracking()

    %{inserted_at: firstDate} = hd(trackings)
    %{inserted_at: lastDate} = List.last(trackings)

    tracking_dates =
      Date.range(DateTime.to_date(firstDate), DateTime.to_date(lastDate))
      |> Enum.to_list()

    empty_map = Map.new(tracking_dates, &{&1, 0})

    tracking_datemap =
      Enum.reduce(trackings, empty_map, fn t, acc ->
        Map.update(acc, DateTime.to_date(t.inserted_at), 1, &(&1 + 1))
      end)

    tracking_datemap_unique =
      Enum.reduce(trackings, %{}, fn t, acc ->
        Map.put(
          acc,
          t.sessionid <> Date.to_string(DateTime.to_date(t.inserted_at)),
          DateTime.to_date(t.inserted_at)
        )
      end)
      |> Enum.reduce(empty_map, fn {_sessid, date}, acc ->
        Map.update(acc, date, 1, &(&1 + 1))
      end)

    posts =
      Core.list_all_posts()
      |> Categories.categorize_posts()

    cat_count =
      Enum.reduce(posts, %{}, fn post, acc -> Map.update(acc, post.category, 1, &(&1 + 1)) end)
      |> (&Enum.sort_by(Map.to_list(&1), fn {_key, val} -> -val end)).()

    day_count =
      Enum.reduce(posts, %{}, fn post, acc ->
        Map.update(acc, DateTime.to_date(post.datetime), 1, &(&1 + 1))
      end)
      |> (&Enum.sort_by(Map.to_list(&1), fn {key, _val} -> key end, fn d1, d2 ->
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
            Enum.uniq_by(v1 ++ v2, fn {cat, _link} -> cat end)
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
      day_count: day_count,
      tracking_datemap: tracking_datemap,
      tracking_dates: tracking_dates,
      tracking_datemap_unique: tracking_datemap_unique
    })
  end
end
