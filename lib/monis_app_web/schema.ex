defmodule MonisAppWeb.Schema do
  use Absinthe.Schema

  query do
    field :user, :user do
      arg(:id, non_null(:string))
      resolve(&MonisAppWeb.UserResolver.user/2)
    end

    field :accounts, list_of(non_null :account) do
      middleware MonisAppWeb.AuthenticationMiddleware
      resolve(&MonisAppWeb.AccountResolver.accounts/2)
    end

  end

  mutation do
    field :login, :login_result do
      arg(:email, non_null(:string))
      arg(:password, non_null(:string))
      resolve(&MonisAppWeb.UserResolver.login/2)
    end

    field :account, :account do
      arg(:name, non_null(:string))
      arg(:type, non_null(:string))
      arg(:icon, :string)
      arg(:currency, :string)
      arg(:amount, :integer)
      resolve(&MonisAppWeb.AccountResolver.create/2)
    end
  end

  object :user do
    field :id, non_null(:string)
    field :email, non_null(:string)
    field :is_active, :boolean
    field :name, :string
  end

  object :account do
    field :amount, non_null(:integer)
    field :currency, non_null(:string)
    field :icon, :string
    field :is_active, :boolean
    field :name, non_null(:string)
    field :type, non_null(:string)
    field :user, non_null(:user) do
      resolve fn account, _, _ ->
        batch({__MODULE__, :users_by_id}, account.user_id, fn result -> {:ok, Map.get(result, account.user_id)} end)
      end
    end
  end

  object :login_result do
    field :token, non_null(:string)
    field :user, non_null(:user)
  end

  def users_by_id(_, user_ids) do
    users = MonisApp.Auth.list_users(user_ids)
    Map.new(users, fn u -> {u.id, u} end)
  end
end
