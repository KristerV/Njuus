defmodule Njuus.ReleaseTasks do
  def migrate do
    {:ok, _} = Application.ensure_all_started(:njuus)

    path = Application.app_dir(:njuus, "priv/repo/migrations")

    Ecto.Migrator.run(Njuus.Repo, path, :up, all: true)
  end
end
