defmodule ChatApp.DatabaseAdapter do
  @type entity :: tuple() | map() | struct()

  def insert(schema, entity) do
    :ets.insert_new(schema.schema_name(), entity)
  end

  def update(schema, entity) do
    :ets.insert(schema.schema_name(), entity)
  end

  def delete(schema, id) do
    :ets.delete(schema.schema_name(), id)
  end

  def get(schema, id) do
    :ets.lookup(schema.schema_name(), id)
  end

  def get_all(schema) do
    :ets.tab2list(schema.schema_name())
  end

  def exists?(schema, id) do
    :ets.member(schema.schema_name(), id)
  end

end
