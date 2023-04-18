defmodule ChatApp.DatabaseAdapter do
  @type entity :: tuple() | map() | struct()
  @callback insert(entity) :: {:ok, entity} | {:error, String.t()}
  @callback get(Ecto.UUID) :: {:ok, entity} | {:error, String.t()}
  @callback update(Ecto.UUID, entity) :: {:ok, entity} | {:error, String.t()}
  @callback delete(Ecto.UUID) :: {:ok, entity} | {:error, String.t()}
end
