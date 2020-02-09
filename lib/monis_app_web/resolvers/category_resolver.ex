defmodule MonisAppWeb.CategoryResolver do
  @moduledoc """
  Resolvers for the Graphql Category object
  """

  def categories(params, %{context: %{user: user}}) do
    categories = Map.merge(%{user_id: user.id}, params)
      |> MonisApp.Finance.list_category
    {:ok, categories}
  end

  def categories(params, _) do
    categories = MonisApp.Finance.list_category(params)
    {:ok, categories}
  end
end
