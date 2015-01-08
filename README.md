# ElixirChat

This is a toy application intended to stress the capabilities of Phoenix and Elixir
to handle the load of a modern chat application.

This server is intended to be used with [seejee/node-chat-client](https://github.com/seejee/node-chat-client).

# Development

1. Install dependencies with `mix deps.get`
2. Start Phoenix endpoint with `mix phoenix.server`

Now you can visit `localhost:4000` from your browser.

# Production

1. `MIX_ENV=prod mix do clean, compile, compile.protocols && MIX_ENV=prod PORT=4000 elixir -pa _build/prod/consolidated -S mix phoenix.server`
