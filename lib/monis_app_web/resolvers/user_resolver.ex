defmodule MonisAppWeb.UserResolver do
  
  alias MonisApp.Auth
  alias MonisApp.Auth.User

  def user(%{id: user_id}, _) do
    {:ok, MonisApp.Auth.get_user!(user_id)}
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
