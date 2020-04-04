defmodule MonisApp.Repo.Migrations.CreateTransactions do
  use Ecto.Migration

  def change do
    create table(:transactions, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :comment, :string
      add :payee, :string, null: false
      add :value, :numeric, null: false
      add :transaction_date, :date, null: false
      add :category_id, references(:category, on_delete: :nothing, type: :binary_id), null: false
      add :account_id, references(:accounts, on_delete: :delete_all, type: :binary_id), null: false

      timestamps()
    end

    create index(:transactions, [:category_id])
    create index(:transactions, [:account_id])
  end
end
