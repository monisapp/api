defmodule MonisAppWeb.Schema do
  use Absinthe.Schema

  query do
    field :user, :user do
      arg(:id, non_null(:string))
      resolve(&MonisAppWeb.UserResolver.user/2)
    end
  end

  mutation do
    field :login, :login_result do
      arg(:email, non_null(:string))
      arg(:password, non_null(:string))
      resolve(&MonisAppWeb.UserResolver.login/2)
    end
  end

  object :user do
    field :id, non_null(:string)
    field :email, non_null(:string)
    field :is_active, :boolean
    field :name, :string
  end

  object :login_result do
    field :token, non_null(:string)
    field :user, non_null(:user)
  end
end
