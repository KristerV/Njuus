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
    from(p in query_posts(settings), limit: 200, order_by: [desc: p.datetime])
    |> Repo.all()
  end

  def list_posts(%Njuus.Settings{} = settings, hours) when is_integer(hours) do
    from(p in query_posts(settings),
      where: p.datetime > ^Timex.shift(Timex.now(), hours: -hours),
      limit: 200,
      order_by: [desc: p.datetime]
    )
    |> Repo.all()
  end

  def list_posts(%Njuus.Settings{} = settings, filter_ids) when is_list(filter_ids) do
    from(p in query_posts(settings),
      limit: 200,
      order_by: [desc: p.datetime],
      where: p.id not in ^filter_ids
    )
    |> Repo.all()
  end

  def list_top_posts(%Njuus.Settings{} = settings, hours) do
    from(p in query_posts(settings),
      where: p.datetime > ^Timex.shift(Timex.now(), hours: -hours),
      limit: 10,
      order_by: [desc_nulls_last: fragment("array_length(?, 1)", p.votes)],
      order_by: [desc: p.datetime]
    )
    |> IO.inspect()
    |> Repo.all()
  end

  def query_posts(%Njuus.Settings{} = settings) do
    from(p in Post,
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
      # Some posts have a single cat that is useless
      where:
        not ((fragment("array_length(?, 1) = 0", p.categories) or
                fragment(
                  "array_length(?, 1) = 1 AND ? && ?::character varying[]",
                  p.categories,
                  p.categories,
                  ^Application.get_env(:njuus, Njuus.Core.Categories)[:pairs_ignore]
                )) and
               p.provider in ^Categories.get_default_providers(settings.filters.category))
    )
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
