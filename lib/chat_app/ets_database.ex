defmodule ChatApp.ETSDatabase do
  @tables [
    %{name: :rooms, properties: [:set, :public, :named_table]},
    %{name: :messages, properties: [:set, :public, :named_table]}
  ]

  def parse_tables() do
    Enum.map(@tables, fn row ->
      {row.name, row.properties}
    end)
  end
end
