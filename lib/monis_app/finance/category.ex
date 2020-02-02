defmodule MonisApp.Finance.Category do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "category" do
    field :icon, :string
    field :name, :string
    field :type, :string
    field :user_id, :binary_id, default: nil

    timestamps()
  end

  @doc false
  def changeset(category, attrs) do
    category
      |> cast(attrs, [:user_id, :name, :type, :icon])
      |> validate_required([:name, :type, :icon])
  end
end
