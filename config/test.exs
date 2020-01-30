use Mix.Config

# Configure your database
config :monis_app, MonisApp.Repo,
  username: "postgres",
  password: "postgres",
  database: "monis_app_test",
  hostname: "localhost",
  pool: Ecto.Adapters.SQL.Sandbox

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :monis_app, MonisAppWeb.Endpoint,
  http: [port: 4002],
  server: false

# Print only warnings and errors during test
config :logger, level: :warn
