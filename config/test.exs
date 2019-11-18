use Mix.Config

# Configure your database
config :stream_heda, StreamHeda.Repo,
  username: "postgres",
  password: "postgres",
  database: "stream_heda_test",
  hostname: "localhost",
  pool: Ecto.Adapters.SQL.Sandbox

# Configure your database
config :stream_heda, StreamHeda.Repo,
  username: "postgres",
  password: "postgres",
  database: "stream_heda_test",
  hostname: "localhost",
  pool: Ecto.Adapters.SQL.Sandbox

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :stream_heda, StreamHedaWeb.Endpoint,
  http: [port: 4002],
  server: false

# Print only warnings and errors during test
config :logger, level: :warn
