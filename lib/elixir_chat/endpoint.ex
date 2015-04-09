defmodule ElixirChat.Endpoint do
  use Phoenix.Endpoint, otp_app: :elixir_chat

  plug Plug.Static,
      at: "/", from: :elixir_chat,
      only: ~w(css images js favicon.ico robots.txt)

  plug Plug.Logger

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

  if code_reloading? do
    plug Phoenix.CodeReloader
  end
end
