%{
  configs: [
    %{
      name: "default",
      files: %{
        included: ["config/", "lib/", "priv/", "test/"],
        excluded: []
      }
    }
  ]
}
