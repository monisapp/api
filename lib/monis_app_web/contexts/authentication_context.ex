defmodule MonisAppWeb.AuthenticationContext do
  @moduledoc """
  Forwarder to include authenticated user into the application context
  """

  @behaviour Plug
  import Plug.Conn

  def init(opts) do
    opts
  end

  def call(conn, _opts) do
    with ["Bearer " <> token] <- conn |> get_req_header("authorization"),
         {:ok, %MonisApp.Auth.User{} = user, _} <- MonisApp.Guardian.resource_from_token(token)
    do
      conn |> Absinthe.Plug.put_options(context: %{user: user})
    else
      _ -> conn
    end
  end
end
