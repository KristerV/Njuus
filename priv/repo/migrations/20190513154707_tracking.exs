defmodule Njuus.Repo.Migrations.Tracking do
  use Ecto.Migration

  def change do
    create table(:tracking) do
      add :sessionid, :string
      add :route, :string
      add :ip, :string

      timestamps()
    end
  end
end
