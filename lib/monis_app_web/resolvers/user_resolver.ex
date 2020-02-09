defmodule MonisAppWeb.UserResolver do
  @moduledoc """
  Resolvers for the Graphql User object
  """

  alias MonisApp.Auth
  alias MonisApp.Auth.User

  def user(_, %{context: %{user: user}}) do
    {:ok, user}
  end

  def create(%{password: password, password_confirm: password_confirm} = params, _) do
    if password != password_confirm do
      {:error, "Password and confirmation do not match"}
    else
      with {:ok, %User{} = user} <- Auth.create_user(params),
           {:ok, token, _} <- user |> MonisApp.Guardian.encode_and_sign
      do
        {:ok, %{token: token, user: user}}
      else
        _ -> {:error, "Could not create user"}
      end
    end
  end

  def login(%{email: email, password: password}, _) do
    with {:ok, %User{} = user} <- Auth.authenticate_user(email, password),
         {:ok, token, _} <- MonisApp.Guardian.encode_and_sign(user)
    do
      {:ok, %{token: token, user: user}}
    else
      _ -> {:error, "Invalid email or password"}
    end
  end
end
