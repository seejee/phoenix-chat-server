defmodule ElixirChat.UserSocket do
  use Phoenix.Socket

  channel "chats:*",    ElixirChat.ChatChannel
  channel "presence:*", ElixirChat.PresenceChannel

  transport :websocket, Phoenix.Transports.WebSocket

  def connect(_params, socket), do: {:ok, socket}

  def id(_socket), do: nil
end
