defmodule NjuusWeb.AdminController do
  use NjuusWeb, :controller

  alias Njuus.Core
  alias Njuus.Core.Post

  def index(conn, _params) do
    posts = Core.list_posts()

    categories =
      Enum.reduce(posts, %{}, fn post, acc ->
        catLink =
          post.categories
          |> Enum.map(fn cat -> {cat, post.link} end)

        Map.merge(acc, %{post.provider() => catLink}, fn _k, v1, v2 ->
          Enum.uniq_by(v1 ++ v2, fn {cat, link} -> cat end)
        end)
      end)

    render(conn, "index.html", categories: categories)
  end
end
