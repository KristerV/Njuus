defmodule Njuus.Repo.Migrations.Votes do
  use Ecto.Migration

  def change do
    alter table(:posts) do
      modify :votes, {:array, :string}
    end
  end
end
