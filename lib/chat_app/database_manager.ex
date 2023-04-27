defmodule ChatApp.DatabaseManager do
  use GenServer
  require Logger
  @name __MODULE__

  def start_link(args) do
    Logger.info("DatabaseManager: start_link called.")
    GenServer.start_link(@name, args, name: @name)
  end

  @impl true
  def init([module_name]) do
    Logger.info("DatabaseManager: init called.")
    {:ok, %{module: module_name}}
  end

  def insert(entity), do: GenServer.call(@name, {:insert, entity})
  def get(entity), do: GenServer.call(@name, {:get, entity})
  def update(entity), do: GenServer.call(@name, {:update, entity})
  def delete(entity), do: GenServer.call(@name, {:delete, entity})

  @impl true
  def handle_call(operation, _from, state) do
    Logger.info("DatabaseManager: handle_call executed.")
    database_module = Map.get(state, :module)

    case operation do
      {:insert, entity} -> {:reply, database_module.insert(entity), state}
      {:get, entity} -> {:reply, database_module.get(entity), state}
      {:update, entity} -> {:reply, database_module.update(entity), state}
      {:delete, entity} -> {:reply, database_module.delete(entity), state}
    end
  end
end
