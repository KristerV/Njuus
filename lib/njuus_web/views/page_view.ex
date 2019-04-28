defmodule NjuusWeb.PageView do
  use NjuusWeb, :view

  def get_link(post) do
    if post.link == "" do
      link "Show", to: Routes.post_path(@conn, :show, post)
    else
      post.link
    end
  end
end
