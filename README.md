# ElixirChat

This is a toy application intended to stress the capabilities of Phoenix and Elixir to handle the load of a modern chat
application. It was originally created for a [Codemash 2015 talk](http://www.codemash.org/session/callback-free-concurrency-elixir-vs-node/).

This server is intended to be used with [seejee/node-chat-client](https://github.com/seejee/node-chat-client) and
serves as a foil to [seejee/node-chat-server](https://github.com/seejee/node-chat-server)

## Running

### Development

1. Install dependencies with `mix deps.get`
2. Start Phoenix endpoint with `mix phoenix.server`

Visit `localhost:4000` from your browser.

### Production

1. `MIX_ENV=prod mix do clean, compile, compile.protocols`
2. `MIX_ENV=prod PORT=4000 elixir -pa _build/prod/consolidated -S mix phoenix.server`

## Architecure Overview

This system simulates a student/teacher chat system where students wait in a queue until a teacher is available to chat
with them. Teachers are able to chat with up to five students at a time. Teachers periodically try to pick up new
students, and if one is available, the student and teacher will enter a private chat room.i

Once the student and teacher chat for a while, the teacher ends the chat and the student disconnects. The teacher then picks up the next student from the queue.

The components for this system are as follows:

### Teacher Roster / Teacher Roster Server

Responsible for keeping track of which teachers are online.

### Student Roster / Student Roster Server

Responsible for keeping track of which students are online.

### Chat Log / Chat Log Server

Responsible for keeping track of which chats are in progress. Each chat also keeps track of whether the student and
teacher have entered the private channel.

### Chat Lifetime Server

Interacts with the Teacher Roster Server, Student Roster Server, and Chat Log Server to initate a new chat. It is
implemented as its own GenServer to provide synchronization around pulling a student out the queue, assigning them to a
teacher, and then creating the new chat.

### Presence Channel

1. Handles students and teachers connecting and disconnecting.
2. Handles teachers trying to initiate a new chat.
3. Publishes how many teachers and students are online to all connected teachers.

### Chat Channel

1. Handles students and teachers joining a private topic.
2. Handles the chat being terminated by a student.
