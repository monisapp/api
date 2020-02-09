defmodule MonisAppWeb.TransactionResolver do
  alias MonisApp.Finance

  def create_transaction(input, %{context: %{user: user}}) do
    with {:ok, _} <- Finance.get_account_by(user_id: user.id, id: input.account_id),
         {:ok, transaction} <- Finance.create_transaction(input) do
      {:ok, %{transaction: transaction}}
    end
  end

  def transactions(params, %{context: %{user: user}}) do
    {:ok, Finance.list_transactions(params |> Map.put(:user_id, user.id))}
  end
end
