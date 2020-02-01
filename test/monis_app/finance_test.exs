defmodule MonisApp.FinanceTest do
  use MonisApp.DataCase

  alias MonisApp.Finance

  describe "accounts" do
    alias MonisApp.Finance.Account

    @valid_attrs %{amount: 42, currency: "some currency", icon: "some icon", initial_balance: 42, is_active: true, name: "some name", type: "some type"}
    @update_attrs %{amount: 43, currency: "some updated currency", icon: "some updated icon", initial_balance: 43, is_active: false, name: "some updated name", type: "some updated type"}
    @invalid_attrs %{amount: nil, currency: nil, icon: nil, initial_balance: nil, is_active: nil, name: nil, type: nil}

    def account_fixture(attrs \\ %{}) do
      {:ok, account} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Finance.create_account()

      account
    end

    test "list_accounts/0 returns all accounts" do
      account = account_fixture()
      assert Finance.list_accounts() == [account]
    end

    test "get_account!/1 returns the account with given id" do
      account = account_fixture()
      assert Finance.get_account!(account.id) == account
    end

    test "create_account/1 with valid data creates a account" do
      assert {:ok, %Account{} = account} = Finance.create_account(@valid_attrs)
      assert account.amount == 42
      assert account.currency == "some currency"
      assert account.icon == "some icon"
      assert account.initial_balance == 42
      assert account.is_active == true
      assert account.name == "some name"
      assert account.type == "some type"
    end

    test "create_account/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Finance.create_account(@invalid_attrs)
    end

    test "update_account/2 with valid data updates the account" do
      account = account_fixture()
      assert {:ok, %Account{} = account} = Finance.update_account(account, @update_attrs)
      assert account.amount == 43
      assert account.currency == "some updated currency"
      assert account.icon == "some updated icon"
      assert account.initial_balance == 43
      assert account.is_active == false
      assert account.name == "some updated name"
      assert account.type == "some updated type"
    end

    test "update_account/2 with invalid data returns error changeset" do
      account = account_fixture()
      assert {:error, %Ecto.Changeset{}} = Finance.update_account(account, @invalid_attrs)
      assert account == Finance.get_account!(account.id)
    end

    test "delete_account/1 deletes the account" do
      account = account_fixture()
      assert {:ok, %Account{}} = Finance.delete_account(account)
      assert_raise Ecto.NoResultsError, fn -> Finance.get_account!(account.id) end
    end

    test "change_account/1 returns a account changeset" do
      account = account_fixture()
      assert %Ecto.Changeset{} = Finance.change_account(account)
    end
  end
end
