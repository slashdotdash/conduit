# Conduit

Discover why functional languages, such as Elixir, are ideally suited to building applications following the command query responsibility segregation and event sourcing (CQRS/ES) pattern.

Conduit is a blogging platform, an exemplary Medium.com clone, built as a Phoenix web application.

This is the full source code to accompany the "[Building Conduit](https://leanpub.com/buildingconduit)" eBook.

This book is for anyone who has an interest in CQRS/ES and Elixir. It demonstrates step-by-step how to build an Elixir application implementing the CQRS/ES pattern using the [Commanded](https://github.com/slashdotdash/commanded) open source library.

---

MIT License

[![Build Status](https://travis-ci.com/slashdotdash/conduit.svg?branch=master)](https://travis-ci.com/slashdotdash/conduit)

---

## Getting started

Conduit is an Elixir application using Phoenix 1.4 and PostgreSQL for persistence.

### Prerequisites

You must install the following dependencies before starting:

- [Git](https://git-scm.com/).
- [Elixir](https://elixir-lang.org/install.html) (v1.6 or later).
- [PostgreSQL](https://www.postgresql.org/) database (v9.5 or later).

### Configuring Conduit

1. Clone the Git repo from GitHub:

    ```console
    $ git clone https://github.com/slashdotdash/conduit.git
    ```

2. Install mix dependencies:

    ```console
    $ cd conduit
    $ mix deps.get
    ```

3. Create the event store database:

    ```console
    $ mix do event_store.create, event_store.init
    ```

4. Create the read model store database:

    ```console
    $ mix do ecto.create, ecto.migrate
    ```

5. Run the Phoenix server:

    ```console
    $ mix phx.server
    ```

  This will start the web server on localhost, port 4000: [http://0.0.0.0:4000](http://0.0.0.0:4000)

This application *only* includes the API back-end, serving JSON requests.

You need to choose a front-end from those listed in the [RealWorld repo](https://github.com/gothinkster/realworld). Follow the installation instructions for the front-end you select. The most popular implementations are listed below.

- [React / Redux](https://github.com/gothinkster/react-redux-realworld-example-app)
- [Elm](https://github.com/rtfeldman/elm-spa-example)
- [Angular 4+](https://github.com/gothinkster/angular-realworld-example-app)
- [Angular 1.5+](https://github.com/gothinkster/angularjs-realworld-example-app)
- [React / MobX](https://github.com/gothinkster/react-mobx-realworld-example-app)

Any of these front-ends should integrate with the Conduit back-end due to their common API.

## Running the tests

```console
MIX_ENV=test mix event_store.create
MIX_ENV=test mix event_store.init
MIX_ENV=test mix ecto.create
MIX_ENV=test mix ecto.migrate
mix test
```
## Need help?

Please [submit an issue](https://github.com/slashdotdash/conduit/issues) if you encounter a problem, or need support.
