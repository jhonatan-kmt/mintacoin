import Config

# Configure your database
#
# The MIX_TEST_PARTITION environment variable can be used
# to provide built-in test partitioning in CI environment.
# Run `mix help test` for more information.
config :mintacoin, Mintacoin.Repo,
  username: "postgres",
  password: "postgres",
  hostname: "localhost",
  database: "mintacoin_test#{System.get_env("MIX_TEST_PARTITION")}",
  pool: Ecto.Adapters.SQL.Sandbox,
  pool_size: 10

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :mintacoin, MintacoinWeb.Endpoint,
  http: [ip: {127, 0, 0, 1}, port: 4002],
  secret_key_base: "BaUrx1V02yCkmqNpsnmhRxluI5Qt0q6J5of+SWbvJI6kpde8nFb5MbGIYSaW/vYN",
  server: false

# Execution environment
config :mintacoin, environment: :test

# Print only warnings and errors during test
config :logger, level: :warn

# Initialize plugs at runtime for faster test compilation
config :phoenix, :plug_init_mode, :runtime

# Oban test configuration
config :mintacoin, Oban, testing: :inline

# Encryption variables for accounts signatures
config :mintacoin, encryption_variable: "HQHSCWQ4HNBMLFUWHU2S7H3KGU"

# Stellar SDK configuration
config :stellar_sdk, network: :test
