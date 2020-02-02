defmodule MonisApp.Repo.Migrations.CreateCategory do
  use Ecto.Migration

  def change do
    create table(:category, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :name, :string
      add :type, :string
      add :icon, :string
      add :user_id, references(:users, on_delete: :nothing, type: :binary_id)

      timestamps()
    end

    create index(:category, [:user_id])
  end
end
