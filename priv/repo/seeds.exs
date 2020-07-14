# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     MonisApp.Repo.insert!(%MonisApp.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.

# Default Categories
## Expenses
MonisApp.Finance.create_category(%{
  name: "medic",
  type: "expense",
  icon: "person"
})
MonisApp.Finance.create_category(%{
  name: "food",
  type: "expense",
  icon: "basket"
})
MonisApp.Finance.create_category(%{
  name: "eating out",
  type: "expense",
  icon: "clutery"
})
MonisApp.Finance.create_category(%{
  name: "bills",
  type: "expense",
  icon: "bill"
})
MonisApp.Finance.create_category(%{
  name: "education",
  type: "expense",
  icon: "book"
})
MonisApp.Finance.create_category(%{
  name: "transport",
  type: "expense",
  icon: "car"
})
MonisApp.Finance.create_category(%{
  name: "salary",
  type: "income",
  icon: "money"
})
MonisApp.Finance.create_category(%{
  name: "savings",
  type: "income",
  icon: "piggybank"
})
MonisApp.Finance.create_category(%{
  name: "deposits",
  type: "income",
  icon: "cash_bag"
})
