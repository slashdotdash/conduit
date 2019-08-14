FROM elixir:1.9

RUN mix local.hex --force && mix local.rebar --force

WORKDIR /app

COPY mix.exs mix.lock ./
RUN mix do deps.get, deps.compile

COPY . ./
RUN mix compile

CMD ./start.sh
