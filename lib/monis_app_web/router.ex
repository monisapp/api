defmodule MonisAppWeb.Router do
  use MonisAppWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  pipeline :graphql do
    plug MonisAppWeb.AuthenticationContext
  end

  scope "/api", MonisAppWeb do
    pipe_through :api
  end

  scope "/" do
    pipe_through :graphql
    forward "/graphql", Absinthe.Plug, schema: MonisAppWeb.Schema

    if Mix.env() == :dev do
      forward "/graphiql", Absinthe.Plug.GraphiQL, schema: MonisAppWeb.Schema
    end
  end
end
