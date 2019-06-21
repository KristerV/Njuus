# Njuus

Njuus is an Estonian news aggregator, check it out at [njuus.ee](https://njuus.ee).

To start your Phoenix server:

  * Configure PostgreSQL with user and password `postgres` (as defined in `config/dev.exs`)
  * Start your PostgreSQL server with `systemctl start postgresql` (or consult Google)
  * Install dependencies with `mix deps.get`
  * Create and migrate your database with `mix ecto.setup`
  * Install Node.js dependencies with `(cd assets && npm install)`
  * Start Phoenix endpoint with `mix do ecto.migrate, phx.server`

Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.

## Deploy to server

Just run `deploy.sh`.

Full guide at [Distillery website](https://github.com/bitwalker/distillery/blob/master/docs/guides/building_in_docker.md).