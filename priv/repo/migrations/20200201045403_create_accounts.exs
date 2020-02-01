defmodule MonisApp.Repo.Migrations.CreateAccounts do
  use Ecto.Migration

  def change do
    create table(:accounts, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :is_active, :boolean, default: false, null: false
      add :name, :string
      add :amount, :integer
      add :type, :string
      add :currency, :string
      add :icon, :string
      add :user_id, references(:users, on_delete: :nothing, type: :binary_id)

      timestamps()
    end

    create index(:accounts, [:user_id])
  end
end
