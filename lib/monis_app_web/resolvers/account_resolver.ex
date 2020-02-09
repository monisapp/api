defmodule MonisAppWeb.AccountResolver do
  alias MonisApp.Finance

  @create_defaults %{amount: 0, currency: "BRL", icon: "generic_money"}

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
      rest -> rest
    end
  end
end
