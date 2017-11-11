use Mix.Config

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :conduit, ConduitWeb.Endpoint,
  http: [port: 4001],
  server: false

# Print only warnings and errors during test
config :logger, level: :warn

config :ex_unit,
  capture_log: true

config :commanded,
  event_store_adapter: Commanded.EventStore.Adapters.InMemory

# Configure the read store database
config :conduit, Conduit.Repo,
  adapter: Ecto.Adapters.Postgres,
  username: "postgres",
  password: "postgres",
  database: "conduit_readstore_test",
  hostname: "localhost",
  pool: Ecto.Adapters.SQL.Sandbox,
  pool_size: 1

config :comeonin, :bcrypt_log_rounds, 4
