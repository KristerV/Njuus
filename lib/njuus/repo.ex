defmodule Njuus.Repo do
  use Ecto.Repo,
    otp_app: :njuus,
    adapter: Ecto.Adapters.Postgres
end
