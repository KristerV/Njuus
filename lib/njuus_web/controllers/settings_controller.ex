defmodule NjuusWeb.SettingsController do
  use NjuusWeb, :controller

  alias Njuus.Core.Categories
  alias Njuus.Settings

  def index(conn, _params) do
    render(conn, "index.html", %{
      settings: get_session(conn, "settings"),
      providers: Njuus.Feeds.get_providers(),
      categories: Categories.get_all(),
      icons: Application.get_env(:njuus, Categories)[:icons]
    })
  end
end
