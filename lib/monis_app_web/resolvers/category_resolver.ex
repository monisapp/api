defmodule MonisAppWeb.CategoryResolver do
  def categories(params, %{context: %{user: user}}) do
    Map.merge(%{user_id: user.id}, params) |> IO.inspect
    categories = Map.merge(%{user_id: user.id}, params)
      |> MonisApp.Finance.list_category
    {:ok, categories}
  end

  def categories(params, _) do
    categories = MonisApp.Finance.list_category(params)
    {:ok, categories}
  end
end
