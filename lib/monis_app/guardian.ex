defmodule MonisApp.Guardian do
  use Guardian, otp_app: :monis_app

  def subject_for_token(%{id: id}, _claims) do
    subject = to_string(id)
    {:ok, subject}
  end

  def subject_for_token(_, _) do
    {:error, :invalid_resource}
  end

  def resource_from_claims(%{"sub" => id}) do
    resource = MonisApp.Auth.get_user!(id)
    {:ok, resource}
  end

  def resource_from_claims(_) do
    {:error, :invalid_claims}
  end
end
