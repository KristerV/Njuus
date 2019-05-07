defmodule Njuus.Repo.Migrations.CreatePosts do
  use Ecto.Migration

  def change do
    create table(:posts) do
      add :provider, :string
      add :body, :text
      add :link, :string
      add :title, :text
      add :image, :string
      add :categories, {:array, :string}
      add :datetime, :utc_datetime
      add :source, :string
      add :votes, {:array, :integer}

      timestamps()
    end
  end
end
