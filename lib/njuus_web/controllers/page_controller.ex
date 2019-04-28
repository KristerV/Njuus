defmodule NjuusWeb.PageController do
  use NjuusWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
