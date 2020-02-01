# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :monis_app,
  ecto_repos: [MonisApp.Repo],
  generators: [binary_id: true]

# Configures the endpoint
config :monis_app, MonisAppWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "GF/kewmuyFiaTqJVmEpkhNjbFm7rGde48m4u2VLjj9W7lSssThW9D1aeuVPK/3WB",
  render_errors: [view: MonisAppWeb.ErrorView, accepts: ~w(json)],
  pubsub: [name: MonisApp.PubSub, adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

config :monis_app, MonisApp.Guardian,
  issuer: "monis_app",
  secret_key: "m+E1aQULDIXXf+N0yvILN9OrqBmIl3pEw31HMnGxMKYMYE55xvtrJFbzTs+XdqEU"

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
