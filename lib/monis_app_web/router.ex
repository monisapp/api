defmodule MonisAppWeb.Router do
  use MonisAppWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api", MonisAppWeb do
    pipe_through :api

    get "/hello", HelloController, :index
    get "/user/:id", UserController, :show
  end

  scope "/" do
    forward "/graphql", Absinthe.Plug, schema: MonisAppWeb.Schema

    if Mix.env() == :dev do
      forward "/graphiql", Absinthe.Plug.GraphiQL, schema: MonisAppWeb.Schema
    end
  end
end
