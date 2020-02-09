defmodule MonisAppWeb.TransactionResolver do
  alias MonisApp.Finance

  def create_transaction(input, %{context: %{user: user}}) do
    with {:ok, _} <- Finance.get_account_by(user_id: user.id, id: input.account_id),
         {:ok, transaction} <- Finance.create_transaction(input) do
      {:ok, %{transaction: transaction}}
    end
  end
end
