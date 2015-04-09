use Mix.Config

config :elixir_chat, ElixirChat.Endpoint,
  http: [port: System.get_env("PORT") || 4000],
  debug_errors: true

# Enables code reloading for development
config :elixir_chat, ElixirChat.Endpoint, code_reloader: true
