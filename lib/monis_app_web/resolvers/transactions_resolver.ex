defmodule MonisAppWeb.TransactionResolver do
  alias MonisApp.Finance

  @moduledoc """
  Resolvers for the Graphql Transaction object
  """

  def create_transaction(input, %{context: %{user: user}}) do
    # Ensure account exists, throws exception if not
    Finance.get_account_by!(user_id: user.id, id: input.account_id)

    case Finance.create_transaction(input) do
      {:ok, transaction} ->
        {:ok, %{transaction: transaction}}
      rest -> rest
    end
  end

  def transactions(params, %{context: %{user: user}}) do
    {:ok, Finance.list_transactions(params |> Map.put(:user_id, user.id))}
  end
end
