defmodule MonisAppWeb.AccountResolver do
  @create_defaults %{amount: 0, currency: "BRL", icon: "generic_money"}
  
  def accounts(_, %{context: %{user: user}}) do
    loaded = MonisApp.Finance.list_accounts(user.id)
    {:ok, loaded}
  end

  def create(params, %{context: %{user: user}}) do
    Map.merge(@create_defaults, params)
      |> Map.merge(%{user_id: user.id})
      |> MonisApp.Finance.create_account
  end
end
