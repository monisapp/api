defmodule MonisAppWeb.AuthenticationMiddleware do
  @moduledoc """
  Middleware to ensure user authentication
  """

  @behaviour Absinthe.Middleware

  def call(resolution, _config) do
    case resolution.context do
      %{user: _user} -> resolution
      _ -> resolution |> Absinthe.Resolution.put_result({:error, "unauthenticated"})
    end
  end
end
