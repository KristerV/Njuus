defmodule NjuusWeb.PageController do
  use NjuusWeb, :controller

  alias Njuus.Core
  alias Njuus.Core.Categories
  alias Njuus.Settings

  def index(conn, _params) do
    settings = %Settings{} = get_session(conn, "settings") || Settings.new()

    posts =
      Core.list_posts(settings)
      |> Categories.categorize_posts()

    icons = Application.get_env(:njuus, Categories)[:icons]

    render(conn, "index.html", %{posts: posts, icons: icons})
  end
end
