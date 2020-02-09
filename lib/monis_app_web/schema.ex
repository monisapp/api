defmodule MonisAppWeb.Schema do
  use Absinthe.Schema
  use Absinthe.Relay.Schema, :modern

  node interface do
    resolve_type(fn
      %MonisApp.Auth.User{}, _ ->
        :user

      %MonisApp.Finance.Account{}, _ ->
        :account

      %MonisApp.Finance.Category{}, _ ->
        :category

      %MonisApp.Finance.Transaction{}, _ ->
        :transaction
    end)
  end

  query do
    node field do
      resolve(fn
        %{type: :user, id: id}, _ ->
          {:ok, MonisApp.Auth.get_user!(id)}

        %{type: :account, id: id}, _ ->
          {:ok, MonisApp.Finance.get_account!(id)}

        %{type: :category, id: id}, _ ->
          {:ok, MonisApp.Finance.get_category!(id)}

        %{type: :transaction, id: id}, _ ->
          {:ok, MonisApp.Finance.get_transaction!(id)}
      end)
    end

    field :transactions, non_null(list_of(non_null(:transaction))) do
      arg(:account_id, :id)
      arg(:category_id, :id)
      arg(:id, :id)
      middleware(MonisAppWeb.AuthenticationMiddleware)

      resolve(
        parsing_node_ids(&MonisAppWeb.TransactionResolver.transactions/2,
          account_id: :account,
          category_id: :category,
          id: :transaction
        )
      )
    end

    field :user, non_null(:user) do
      middleware(MonisAppWeb.AuthenticationMiddleware)
      resolve(&MonisAppWeb.UserResolver.user/2)
    end

    field :accounts, list_of(non_null(:account)) do
      middleware(MonisAppWeb.AuthenticationMiddleware)
      resolve(&MonisAppWeb.AccountResolver.accounts/2)
    end

    field :categories, list_of(non_null(:category)) do
      arg(:type, :string)
      resolve(&MonisAppWeb.CategoryResolver.categories/2)
    end
  end

  mutation do
    field :login, :login_result do
      arg(:email, non_null(:string))
      arg(:password, non_null(:string))
      resolve(&MonisAppWeb.UserResolver.login/2)
    end

    payload field :register do
      input do
        field :email, non_null(:string)
        field :password, non_null(:string)
        field :password_confirm, non_null(:string)
        field :name, non_null(:string)
      end

      output do
        field :token, non_null(:string)
        field :user, non_null(:user)
      end

      resolve(&MonisAppWeb.UserResolver.create/2)
    end

    payload field :create_account do
      input do
        field(:name, non_null(:string))
        field(:type, non_null(:string))
        field(:icon, :string)
        field(:currency, :string)
        field(:amount, :integer)
      end

      output do
        field(:account, non_null(:account))
      end

      middleware(MonisAppWeb.AuthenticationMiddleware)
      resolve(&MonisAppWeb.AccountResolver.create/2)
    end

    payload field :create_transaction do
      input do
        field(:payee, non_null(:string))
        field(:value, non_null(:integer))
        field(:transaction_date, non_null(:string))
        field(:category_id, non_null(:id))
        field(:account_id, non_null(:id))
        field(:comment, :string)
      end

      output do
        field :transaction, non_null(:transaction)
      end

      middleware(MonisAppWeb.AuthenticationMiddleware)

      resolve(
        parsing_node_ids(&MonisAppWeb.TransactionResolver.create_transaction/2,
          account_id: :account,
          category_id: :category
        )
      )
    end
  end

  node object(:user) do
    field :email, non_null(:string)
    field :is_active, non_null(:boolean)
    field :name, non_null(:string)
  end

  node object(:account) do
    field :amount, non_null(:integer)
    field :currency, non_null(:string)
    field :icon, :string
    field :is_active, :boolean
    field :name, non_null(:string)
    field :type, non_null(:string)

    field :user, non_null(:user) do
      resolve(fn account, _, _ ->
        batch({__MODULE__, :users_by_id}, account.user_id, fn result ->
          {:ok, Map.get(result, account.user_id)}
        end)
      end)
    end
  end

  def users_by_id(_, user_ids) do
    MonisApp.Auth.list_users(user_ids)
    |> Map.new(fn u -> {u.id, u} end)
  end

  object :login_result do
    field :token, non_null(:string)
    field :user, non_null(:user)
  end

  node object(:category) do
    field :name, non_null(:string)
    field :icon, non_null(:string)
    field :type, non_null(:string)
  end

  node object(:transaction) do
    field(:payee, non_null(:string))
    field(:value, non_null(:integer))
    field(:transaction_date, non_null(:string))
    field(:comment, :string)
    # TODO: Add account and category field
  end
end
