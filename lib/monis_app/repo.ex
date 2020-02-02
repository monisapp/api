defmodule MonisApp.Repo do
  use Ecto.Repo,
    otp_app: :monis_app,
    adapter: Ecto.Adapters.Postgres

  def init(_, config) do
    config =
      config
      |> Keyword.put(:username, System.get_env("PGUSER", config |> Keyword.get(:username)))
      |> Keyword.put(:password, System.get_env("PGPASSWORD", config |> Keyword.get(:password)))
      |> Keyword.put(:database, System.get_env("PGDATABASE", config |> Keyword.get(:database)))
      |> Keyword.put(:hostname, System.get_env("PGHOST", config |> Keyword.get(:host, "localhost")))
      |> Keyword.put(:port, System.get_env("PGPORT", config |> Keyword.get(:port, "5432")) |> String.to_integer())

    {:ok, config}
  end
end
