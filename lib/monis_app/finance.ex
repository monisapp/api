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
  def get_account_by(opts), do: Repo.get_by(Account, opts)

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
  def list_category() do
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

  alias MonisApp.Finance.Transaction

  @doc """
  Returns the list of transactions.

  ## Examples

      iex> list_transactions()
      [%Transaction{}, ...]

  """
  def list_transactions do
    Repo.all(Transaction)
  end

  @doc """
  Gets a single transaction.

  Raises `Ecto.NoResultsError` if the Transaction does not exist.

  ## Examples

      iex> get_transaction!(123)
      %Transaction{}

      iex> get_transaction!(456)
      ** (Ecto.NoResultsError)

  """
  def get_transaction!(id), do: Repo.get!(Transaction, id)

  @doc """
  Creates a transaction.

  ## Examples

      iex> create_transaction(%{field: value})
      {:ok, %Transaction{}}

      iex> create_transaction(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_transaction(attrs \\ %{}) do
    %Transaction{}
    |> Transaction.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a transaction.

  ## Examples

      iex> update_transaction(transaction, %{field: new_value})
      {:ok, %Transaction{}}

      iex> update_transaction(transaction, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_transaction(%Transaction{} = transaction, attrs) do
    transaction
    |> Transaction.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a transaction.

  ## Examples

      iex> delete_transaction(transaction)
      {:ok, %Transaction{}}

      iex> delete_transaction(transaction)
      {:error, %Ecto.Changeset{}}

  """
  def delete_transaction(%Transaction{} = transaction) do
    Repo.delete(transaction)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking transaction changes.

  ## Examples

      iex> change_transaction(transaction)
      %Ecto.Changeset{source: %Transaction{}}

  """
  def change_transaction(%Transaction{} = transaction) do
    Transaction.changeset(transaction, %{})
  end
end
