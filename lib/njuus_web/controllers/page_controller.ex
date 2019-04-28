defmodule NjuusWeb.PageController do
  use NjuusWeb, :controller

  alias Njuus.Core
  alias Njuus.Core.Post

  def index(conn, _params) do
    posts = Core.list_posts()
    render(conn, "index.html", posts: posts)
  end
end
