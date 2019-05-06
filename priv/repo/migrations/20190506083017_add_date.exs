defmodule Njuus.Repo.Migrations.AddDate do
  use Ecto.Migration
  alias Njuus.Core

  def change do
    alter table(:posts) do
      add :datetime, :naive_datetime

      for post <- Core.list_posts() do
        post.datetime_str
        |> Utils.parseDate()
        |> (&Core.update_post(post, %{datetime: &1})).()
      end
    end
  end
end
