defmodule ChatApp.PostgresRepo do
  @behaviour ChatApp.DatabaseAdapter
  alias ChatApp.Repo

  @impl true
  def insert(entity) do
    Repo.insert(entity)
  end

  @impl true
  def delete(entity) do
    Repo.delete(entity)
  end

  @impl true
  def get(entity) do
    %struct_type{} = entity
    Repo.get(struct_type, entity.id)
  end

  @impl true
  def update(entity) do
    %struct_type{} = entity
    struct_type.changeset(entity) |> Repo.update()
  end
end
