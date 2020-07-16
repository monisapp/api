import Logger

defmodule MonisAppWeb.AccountResolver do
  alias MonisApp.Finance

  @moduledoc """
  Resolvers for the Graphql Account object
  """

  @create_defaults %{amount: 0, currency: "BRL", icon: "generic_money"}

  def account(%{account_id: account_id}, _, _) do
    {:ok, Finance.get_account!(account_id)}
  end

  def accounts(_, %{context: %{user: user}}) do
    loaded = Finance.list_accounts(user.id)
    {:ok, loaded}
  end

  def create(params, %{context: %{user: user}}) do
    result =
      Map.merge(@create_defaults, params)
      |> Map.merge(%{user_id: user.id})
      |> Finance.create_account()

    case result do
      {:ok, account} -> {:ok, %{account: account}}
      other -> other
    end
  end

  def delete(%{id: account_id}, %{context: %{user: user}}) do
    user_accounts = Finance.list_accounts(user.id)
    acc = Finance.get_account(account_id)
    not_found_error = {:error, "account not found"}

    if acc != nil do
      has_account = user_accounts
        |> Enum.find_value(false, (fn el -> el.id == acc.id end))

      if has_account do
        case acc |> Finance.delete_account do
          {:ok, account} -> {:ok, %{account: account}}
          other -> other
        end
      else
        not_found_error
      end
    else
      not_found_error
    end
  end
end
