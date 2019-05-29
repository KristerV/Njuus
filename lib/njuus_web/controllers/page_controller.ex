defmodule NjuusWeb.PageController do
  use NjuusWeb, :controller

  alias Njuus.Core
  alias Njuus.Core.Categories
  alias Njuus.Settings

  def index(conn, params) do
    settings = get_session(conn, "settings") || Settings.new()

    hours_selected = String.to_integer(params["p"] || "24")

    top_posts =
      Core.list_top_posts(settings, hours_selected)
      |> Categories.categorize_posts()

    top_post_ids = Enum.map(top_posts, fn item -> item.id end)

    posts =
      Core.list_posts(settings, top_post_ids)
      |> Categories.categorize_posts()

    render(conn, "index.html", %{
      posts: posts,
      icons: Application.get_env(:njuus, Categories)[:icons],
      hours_selected: hours_selected,
      top_posts: top_posts
    })
  end
end
