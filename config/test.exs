use Mix.Config

config :elixir_chat, ElixirChat.Endpoint,
  http: [port: System.get_env("PORT") || 4001]
