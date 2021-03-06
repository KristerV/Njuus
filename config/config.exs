# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :njuus,
  ecto_repos: [Njuus.Repo]

# Configures the endpoint
config :njuus, NjuusWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "BoGNfDAymNswiX5UsmWfpw+p7VOkg/HxpidEJl28aaYSrytcwatxpYJri4sXaJdj",
  render_errors: [view: NjuusWeb.ErrorView, accepts: ~w(html json)],
  pubsub: [name: Njuus.PubSub, adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

config :njuus, Njuus.Scheduler,
  jobs: [
    {"@reboot", {Njuus.Feeds, :start, []}},
    # Every 15 minutes
    {"*/3 * * * *", {Njuus.Feeds, :start, []}}
  ]

import_config "categories.exs"

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
