defmodule MonisApp.Finance do
  @moduledoc """
  The Finance context.
  """

  import Ecto.Query, warn: false
  alias MonisApp.Repo

  alias MonisApp.Finance.{Account, Category}

  # Account

  def list_accounts(user_id) do
    Account
      |> where([a], a.user_id == ^user_id)
      |> Repo.all
  end

  def get_account!(id), do: Repo.get!(Account, id)

  def create_account(attrs \\ %{}) do
    %Account{}
    |> Account.create_changeset(attrs)
    |> Repo.insert()
  end

  def update_account(%Account{} = account, attrs) do
    account
    |> Account.update_changeset(attrs)
    |> Repo.update()
  end

  def delete_account(%Account{} = account) do
    Repo.delete(account)
  end

  def change_account(%Account{} = account) do
    Account.update_changeset(account, %{})
  end

  # Category

  def list_category(opts) do
    filtered = opts |> Enum.filter(fn {k, _} -> k in [:user_id, :type] end)
    case filtered |> Enum.count do
      0 -> list_category()
      _ -> Enum.reduce(opts, Category, fn
          {:user_id, user_id}, query ->
            query
              |> where([c], c.user_id == ^user_id or is_nil(c.user_id))
          {:type, type}, query ->
            query
              |> where([c], c.type == ^type and is_nil(c.user_id))
      end)
      |> Repo.all
    end
  end
  def list_category do
    Category
      |> where([c], is_nil(c.user_id))
      |> Repo.all
  end

  def get_category!(id), do: Repo.get!(Category, id)

  def create_category(attrs \\ %{}) do
    %Category{}
    |> Category.changeset(attrs)
    |> Repo.insert()
  end

  def update_category(%Category{} = category, attrs) do
    category
    |> Category.changeset(attrs)
    |> Repo.update()
  end

  def delete_category(%Category{} = category) do
    Repo.delete(category)
  end

  def change_category(%Category{} = category) do
    Category.changeset(category, %{})
  end
end
