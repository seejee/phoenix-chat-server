use Mix.Config

# ## SSL Support
#
# To get SSL working, you will need to set:
#
#     https: [port: 443,
#             keyfile: System.get_env("SOME_APP_SSL_KEY_PATH"),
#             certfile: System.get_env("SOME_APP_SSL_CERT_PATH")]
#
# Where those two env variables point to a file on
# disk for the key and cert.

config :elixir_chat, ElixirChat.Endpoint,
  url: [host: "example.com"],
  http: [port: System.get_env("PORT")],
  secret_key_base: "/3+SB3ens7zAp3IF4AV0KZhHJsADj//qx0esf3j5cMmwYu1SuZFjOuRv0bid+BB7"

config :logger,
  level: :info
