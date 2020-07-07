#!/usr/bin/env bash

mix do event_store.create, event_store.init
mix do ecto.create, ecto.migrate
mix phx.server
