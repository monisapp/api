defmodule MonisApp.FinanceTest do
  use MonisApp.DataCase

  alias MonisApp.Finance

  describe "accounts" do
    alias MonisApp.Finance.Account

    @valid_attrs %{amount: 42, currency: "some currency", icon: "some icon", is_active: true, name: "some name", type: "some type"}
    @user_atts %{email: "test@test.test", password: "1234", name: "test"}
    @update_attrs %{currency: "some updated currency", icon: "some updated icon", is_active: false, name: "some updated name", type: "some updated type"}
    @invalid_attrs %{amount: nil, currency: nil, icon: nil, is_active: nil, name: nil, type: nil}

    def account_fixture(attrs \\ %{}) do
      {:ok, user} = case attrs do
      %{user_email: email} ->
        Enum.into(%{email: email}, @user_atts) |> MonisApp.Auth.create_user
      %{user_id: id} -> {:ok, %{id: id}}
      _ -> MonisApp.Auth.create_user(@user_atts)
      end
      {:ok, account} =
        Map.merge(%{user_id: user.id}, attrs)
        |> Enum.into(@valid_attrs)
        |> Finance.create_account()

      account
    end

    test "list_accounts/1 returns only accounts for a user" do
      account_fixture(%{user_email: "other@test.test"})
      account1 = account_fixture()
      account2 = account_fixture(%{user_id: account1.user_id})
      accounts = Finance.list_accounts(account1.user_id)
      assert length(accounts) == 2
      assert account1 in accounts
      assert account2 in accounts
    end

    test "get_account!/1 returns the account with given id" do
      account = account_fixture()
      assert Finance.get_account!(account.id) == account
    end

    test "create_account/1 with valid data creates a account" do
      assert %Account{} = account = account_fixture(@valid_attrs)
      assert account.amount == 42
      assert account.currency == "some currency"
      assert account.icon == "some icon"
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
      assert account.currency == "some updated currency"
      assert account.icon == "some updated icon"
      assert account.is_active == false
      assert account.name == "some updated name"
      assert account.type == "some updated type"
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

  describe "category" do
    alias MonisApp.Finance.Category

    @valid_attrs %{icon: "some icon", name: "some name", type: "some type"}
    @update_attrs %{icon: "some updated icon", name: "some updated name", type: "some updated type"}
    @invalid_attrs %{icon: nil, name: nil, type: nil}

    def category_fixture(attrs \\ %{}) do
      {:ok, category} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Finance.create_category()

      category
    end

    test "list_category/0 returns only public categories" do
      {:ok, user} = MonisApp.Auth.create_user(%{email: "test@test.test", password: "1234", name: "test"})
      category_fixture(%{name: "private", type: "expense", icon: "none", user_id: user.id})
      public_fixture = category_fixture(%{name: "public", type: "expense", icon: "none"})
      assert Finance.list_category() == [public_fixture]
    end

    test "list_category/1 with type filter returns only categories matching filter" do
      {:ok, user} = MonisApp.Auth.create_user(%{email: "test@test.test", password: "1234", name: "test"})
      category_fixture(%{name: "private", type: "expense", icon: "none", user_id: user.id})
      income_fixture = category_fixture(%{name: "public", type: "income", icon: "none"})
      expense_fixture = category_fixture(%{name: "public", type: "expense", icon: "none"})

      assert Finance.list_category(%{type: "expense"}) == [expense_fixture]
      assert Finance.list_category(%{type: "income"}) == [income_fixture]
    end

    test "list_category/1 with user filter returns categories from that user" do
      {:ok, another_user} = MonisApp.Auth.create_user(%{email: "test2@test.test", password: "1234", name: "test"})
      category_fixture(%{name: "private", type: "expense", icon: "none", user_id: another_user.id})

      {:ok, user} = MonisApp.Auth.create_user(%{email: "test@test.test", password: "1234", name: "test"})
      user_fixture = category_fixture(%{name: "mine", type: "expense", icon: "none", user_id: user.id})
      public_fixture = category_fixture(%{name: "public", type: "income", icon: "none"})

      assert Finance.list_category(%{user_id: user.id}) == [user_fixture, public_fixture]
    end

    test "get_category!/1 returns the category with given id" do
      category = category_fixture()
      assert Finance.get_category!(category.id) == category
    end

    test "create_category/1 with valid data creates a category" do
      {:ok, user} = MonisApp.Auth.create_user(%{email: "test@test.test", password: "1234", name: "test"})
      assert %Category{} = category = category_fixture(%{user_id: user.id})
      assert category.icon == "some icon"
      assert category.name == "some name"
      assert category.type == "some type"
      assert category.user_id == user.id
    end

    test "create_category/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Finance.create_category(@invalid_attrs)
    end

    test "update_category/2 with valid data updates the category" do
      category = category_fixture()
      assert {:ok, %Category{} = category} = Finance.update_category(category, @update_attrs)
      assert category.icon == "some updated icon"
      assert category.name == "some updated name"
      assert category.type == "some updated type"
    end

    test "update_category/2 with invalid data returns error changeset" do
      category = category_fixture()
      assert {:error, %Ecto.Changeset{}} = Finance.update_category(category, @invalid_attrs)
      assert category == Finance.get_category!(category.id)
    end

    test "delete_category/1 deletes the category" do
      category = category_fixture()
      assert {:ok, %Category{}} = Finance.delete_category(category)
      assert_raise Ecto.NoResultsError, fn -> Finance.get_category!(category.id) end
    end

    test "change_category/1 returns a category changeset" do
      category = category_fixture()
      assert %Ecto.Changeset{} = Finance.change_category(category)
    end
  end

  describe "transactions" do
    alias MonisApp.Finance.Transaction

    @valid_attrs %{comment: "some comment", payee: "some payee", transaction_date: ~D[2010-04-17], value: 42}
    @update_attrs %{comment: "some updated comment", payee: "some updated payee", transaction_date: ~D[2011-05-18], value: 43}
    @invalid_attrs %{comment: nil, payee: nil, transaction_date: nil, value: nil}

    def transaction_fixture(attrs \\ %{}) do
      account = account_fixture()
      category = category_fixture()

      {:ok, transaction} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Enum.into(%{category_id: category.id, account_id: account.id})
        |> Finance.create_transaction()

      transaction
    end

    test "list_transactions/0 returns all transactions" do
      transaction = transaction_fixture()
      assert Finance.list_transactions() == [transaction]
    end

    test "get_transaction!/1 returns the transaction with given id" do
      transaction = transaction_fixture()
      assert Finance.get_transaction!(transaction.id) == transaction
    end

    test "create_transaction/1 with valid data creates a transaction" do
      account = account_fixture()
      category = category_fixture()

      assert {:ok, %Transaction{} = transaction} = Finance.create_transaction(@valid_attrs |> Map.merge(%{category_id: category.id, account_id: account.id}))
      assert transaction.comment == "some comment"
      assert transaction.payee == "some payee"
      assert transaction.transaction_date == ~D[2010-04-17]
      assert transaction.value == 42
    end

    test "create_transaction/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Finance.create_transaction(@invalid_attrs)
    end

    test "update_transaction/2 with valid data updates the transaction" do
      transaction = transaction_fixture()
      assert {:ok, %Transaction{} = transaction} = Finance.update_transaction(transaction, @update_attrs)
      assert transaction.comment == "some updated comment"
      assert transaction.payee == "some updated payee"
      assert transaction.transaction_date == ~D[2011-05-18]
      assert transaction.value == 43
    end

    test "update_transaction/2 with invalid data returns error changeset" do
      transaction = transaction_fixture()
      assert {:error, %Ecto.Changeset{}} = Finance.update_transaction(transaction, @invalid_attrs)
      assert transaction == Finance.get_transaction!(transaction.id)
    end

    test "delete_transaction/1 deletes the transaction" do
      transaction = transaction_fixture()
      assert {:ok, %Transaction{}} = Finance.delete_transaction(transaction)
      assert_raise Ecto.NoResultsError, fn -> Finance.get_transaction!(transaction.id) end
    end

    test "change_transaction/1 returns a transaction changeset" do
      transaction = transaction_fixture()
      assert %Ecto.Changeset{} = Finance.change_transaction(transaction)
    end
  end
end
