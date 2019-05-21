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
end
