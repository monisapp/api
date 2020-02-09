defmodule MonisApp.Finance.Account do
  @moduledoc """
  An account will hold many transactions for the user.

  An user may have many accounts for their different credit cards/bank accounts
  """

  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "accounts" do
    field :amount, :integer, default: 0
    field :currency, :string
    field :icon, :string
    field :is_active, :boolean, default: false
    field :name, :string
    field :type, :string
    belongs_to :user, MonisApp.Auth.User

    timestamps()
  end

  @doc false
  def create_changeset(account, attrs) do
    account
    |> cast(attrs, [:user_id, :is_active, :name, :type, :amount, :currency, :icon])
    |> validate_required([:user_id, :is_active, :name, :type, :currency, :icon])
  end

  @doc false
  def update_changeset(account, attrs) do
    account
    |> cast(attrs, [:is_active, :name, :type, :currency, :icon])
  end
end
