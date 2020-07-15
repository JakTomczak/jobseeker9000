# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :jobseeker9000,
  ecto_repos: [Jobseeker9000.Repo]

# Configures the endpoint
config :jobseeker9000, Jobseeker9000Web.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "0d+oK91injXlYiJq9tByU2QnRi1u4RqS+bB9Tgo+jE5LqQ7zriyfEaNODh9GjOs7",
  render_errors: [view: Jobseeker9000Web.ErrorView, accepts: ~w(html json)],
  pubsub: [name: Jobseeker9000.PubSub, adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

config :jobseeker9000, Jobseeker9000.Repo,
  migration_primary_key: [name: :id, type: :binary_id]

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"