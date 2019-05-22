defmodule NjuusWeb.APIController do
  use NjuusWeb, :controller
  alias Njuus.Core

  def vote_add(conn, params) do
    uuid = get_session(conn, "uuid")
    post = Core.get_post!(params["postid"])

    if Enum.member?(post.votes, uuid) do
      conn
      |> send_resp(400, "already voted")
    else
      Core.update_post(post, %{votes: Enum.uniq(post.votes ++ [uuid])})

      conn
      |> send_resp(200, Integer.to_string(length(post.votes) + 1))
    end
  end

  def vote_rem(conn, params) do
    uuid = get_session(conn, :uuid)
    post = Core.get_post!(params["postid"])

    if Enum.member?(post.votes, uuid) do
      Core.update_post(post, %{votes: Enum.filter(post.votes, fn item -> item != uuid end)})

      conn
      |> send_resp(200, Integer.to_string(length(post.votes) - 1))
    else
      conn
      |> send_resp(400, "you haven't voted")
    end
  end

  def update_user_settings(conn, settings) do
    conn
    |> put_session("settings", settings)
  end

  def add_user_filter(conn, params) do
    current = get_session(conn, "settings") || Njuus.Settings.new()

    newSettings =
      case params["type"] do
        "provider" -> update_in(current.filters.provider, &Enum.uniq(&1 ++ [params["name"]]))
        "category" -> update_in(current.filters.category, &Enum.uniq(&1 ++ [params["name"]]))
      end

    put_session(conn, "settings", newSettings)
    |> send_resp(200, "success")
  end
end
