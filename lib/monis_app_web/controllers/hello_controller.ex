defmodule MonisAppWeb.HelloController do
  use MonisAppWeb, :controller

  def index(conn, _params) do
    conn
    |> json(%{hello: "world"})
  end
end
