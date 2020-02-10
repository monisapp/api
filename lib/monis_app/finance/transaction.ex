defmodule MonisApp.Finance.Transaction do
  use Ecto.Schema
  import Ecto.Changeset

  @moduledoc """
  A transaction represents a movement going out or in an account
  Each transaction has a category
  """

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "transactions" do
    field :comment, :string
    field :payee, :string
    field :transaction_date, :date
    field :value, :integer
    belongs_to :account, MonisApp.Finance.Account
    belongs_to :category, MonisApp.Finance.Category

    timestamps()
  end

  @doc false
  def changeset(transaction, attrs) do
    transaction
    |> cast(attrs, [:comment, :payee, :value, :transaction_date, :account_id, :category_id])
    |> validate_required([:payee, :value, :transaction_date])
    |> foreign_key_constraint(:account)
    |> foreign_key_constraint(:category)
  end
end
