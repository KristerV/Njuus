defmodule Njuus.Repo.Migrations.Indexing do
  use Ecto.Migration

  def change do
    create index(:posts, [:datetime, :source, :categories])
    create index(:tracking, [:inserted_at])
  end
end
