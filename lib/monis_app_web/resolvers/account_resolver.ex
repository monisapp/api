defmodule MonisAppWeb.AccountResolver do
  
  def accounts(_, %{context: %{user: user}}) do
    loaded = MonisApp.Finance.list_accounts(user.id)
      # |> Enum.map(fn acc -> MonisApp.Repo.preload(acc, :user) end)
    {:ok, loaded}
  end
end
