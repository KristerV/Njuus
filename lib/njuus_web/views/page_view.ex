defmodule NjuusWeb.PageView do
  import Plug.Conn
  use NjuusWeb, :view

  def get_voting_class(conn, post) do
    if Enum.member?(post.votes, get_session(conn, :uuid)) do
      ""
    else
      "icon-transparent"
    end
  end
end
