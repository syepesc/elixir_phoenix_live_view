# Elixir Phoenix LiveView

The intent of this repo is to practice my Elixir knowledge by making use of Phoenix framework and Phoenix-LiveView.

Concepts applied:

- [Phoenix](https://hexdocs.pm/phoenix/overview.html) web development framework.
- Server side rendering using [Phoenix LiveView](https://hexdocs.pm/phoenix_live_view/welcome.html).
- [Ecto](https://hexdocs.pm/ecto/Ecto.html) schemas and changesets using Postgres.
- HTML, CSS, and JavaScript.

## How to run the project?

- Install [mise](https://mise.jdx.dev/getting-started.html) (previously `rtx`) , `cd` into the project directory and run:

```bash
mise install
```

- `cd` into the project directory and run the following to install and setup dependencies:

```bash
mix setup
```

- Start Phoenix endpoint with

```bash
mix phx.server
```

OR inside IEx with

```bash
iex -S mix phx.server
```

> Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.

## How to run the test suite of the project?

- `cd` into the project directory and run:

```bash
mix test
```
