defmodule Njuus.Core do
  import Ecto.Query, warn: false
  alias Njuus.Repo

  alias Njuus.Core.Post
  alias Njuus.Tracking
  alias Njuus.Core.Categories

  def list_posts do
    from(p in Post,
      order_by: [desc: p.datetime],
      limit: 200
    )
    |> Repo.all()
  end

  def list_all_posts do
    from(p in Post,
      order_by: [desc: p.datetime]
    )
    |> Repo.all()
  end

  def list_posts(%Njuus.Settings{} = settings) do
    from(p in Post,
      order_by: [desc: p.datetime],
      limit: 200,
      # Filter providers
      where: not (p.provider in ^settings.filters.provider),
      # Filter categories
      where:
        not fragment(
          "? && ?::character varying[]",
          p.categories,
          ^Categories.reverse_summarization(settings.filters.category)
        ),
      # Filter providers that default categories match if their cat is empty
      where:
        not (fragment("array_length(?, 1) = 0", p.categories) and
               p.provider in ^Categories.get_default_providers(settings.filters.category))
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
    count = Repo.one(from p in Post, select: count(), where: p.link == ^attrs.link)

    if count == 0 do
      create_post(attrs)
    else
      false
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
