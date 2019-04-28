defmodule Njuus.Repo.Migrations.CreatePosts do
  use Ecto.Migration

  def change do
    create table(:posts) do
      add :body, :string
      add :link, :string
      add :title, :string
      add :votes, {:array, :integer}

      timestamps()
    end
  end
end
