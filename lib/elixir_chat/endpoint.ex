defmodule ElixirChat.Endpoint do
  use Phoenix.Endpoint, otp_app: :elixir_chat

  plug Plug.Static,
      at: "/", from: :elixir_chat,
      only: ~w(css images js favicon.ico robots.txt)

  plug Plug.Logger

  # Code reloading will only work if the :code_reloader key of
  # the :phoenix application is set to true in your config file.
  plug Phoenix.CodeReloader

  plug Plug.Parsers,
    parsers: [:urlencoded, :multipart, :json],
    pass: ["*/*"],
    json_decoder: Poison

  plug Plug.MethodOverride
  plug Plug.Head

  plug Plug.Session,
    store: :cookie,
    key: "_elixir_chat_key",
    signing_salt: "/3Trf5Ro",
    encryption_salt: "B8xmZqDH"

  plug :router, ElixirChat.Router
end
