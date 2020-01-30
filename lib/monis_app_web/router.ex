defmodule MonisAppWeb.Router do
  use MonisAppWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api", MonisAppWeb do
    pipe_through :api

    get "/hello", HelloController, :index
  end
end
