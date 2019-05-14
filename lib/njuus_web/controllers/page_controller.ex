defmodule NjuusWeb.PageController do
  use NjuusWeb, :controller

  alias Njuus.Core
  alias Njuus.Core.Categories

  def index(conn, _params) do
    posts =
      Core.list_posts()
      |> Categories.categorize_posts()

    icons = Application.get_env(:njuus, Categories)[:icons]

    render(conn, "index.html", %{posts: posts, icons: icons})
  end
end
