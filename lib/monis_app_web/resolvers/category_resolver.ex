defmodule MonisAppWeb.CategoryResolver do
  @moduledoc """
  Resolvers for the Graphql Category object
  """

  def category(%{category_id: category_id}, _, _) do
    {:ok, MonisApp.Finance.get_category!(category_id)}
  end

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
