defmodule ChatApp.DatabaseAdapter do
  @type entity :: tuple() | map() | struct()
  @callback insert(entity) :: {:ok, entity} | {:error, String.t()}
  @callback get(entity) :: {:ok, entity} | {:error, String.t()}
  @callback update(entity) :: {:ok, entity} | {:error, String.t()}
  @callback delete(entity) :: {:ok, entity} | {:error, String.t()}
end
