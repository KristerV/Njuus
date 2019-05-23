defmodule Njuus.Core do
  import Ecto.Query, warn: false
  alias Njuus.Repo

  alias Njuus.Core.Post
  alias Njuus.Tracking
  alias Njuus.Core.Categories

  def list_posts do
    IO.puts("------------ settings 1")

    from(p in Post,
      order_by: [desc: p.datetime],
      limit: 200
    )
    |> Repo.all()
  end

  def list_posts(%Njuus.Settings{} = settings) do
    from(p in Post,
      order_by: [desc: p.datetime],
      limit: 200,
      where: not (p.provider in ^settings.filters.provider),
      where:
        not fragment(
          "? && ?::character varying[]",
          p.categories,
          ^Categories.reverse_summarization(settings.filters.category)
        )
    )
    |> Repo.all()
  end

  def list_tracking do
    from(p in Tracking)
    |> Repo.all()
  end

  def get_post!(id), do: Repo.get!(Post, id)

  def create_post(attrs \\ %{}) do
    %Post{}
    |> Post.changeset(attrs)
    |> Repo.insert()
  end

  def create_post_if_not_exists(attrs) do
    post = Repo.get_by(Post, link: attrs.link)

    if post == nil do
      create_post(attrs)
    else
      post
    end
  end

  def update_post(%Post{} = post, attrs) do
    post
    |> Post.changeset(attrs)
    |> Repo.update()
  end

  def delete_post(%Post{} = post) do
    Repo.delete(post)
  end

  def change_post(%Post{} = post) do
    Post.changeset(post, %{})
  end
end
