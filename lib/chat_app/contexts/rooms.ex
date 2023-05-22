defmodule ChatApp.Contexts.Rooms do
  alias ChatApp.Structs.Room
  alias ChatApp.Repo

  def list_rooms(), do: Repo.all(Room) |> Repo.preload([:messages, :users])

  def get_room(id), do: Repo.get(Room, id)

  def get_room_messages(id) do
    comparator = fn x, y -> DateTime.compare(x.inserted_at, y.inserted_at) == :gt end

    case Repo.get(Room, id) do
      nil ->
        nil

      room ->
        Repo.preload(room, [:messages]).messages
        |> Enum.map(fn message -> Repo.preload(message, [:reactions]) end)
        |> Enum.sort(comparator)
    end
  end

  def get_room_users(id) do
    case Repo.get(Room, id) do
      nil -> nil
      room -> Repo.preload(room, [:users]).users
    end
  end

  def update_room(%Room{} = room, attrs) do
    room
    |> Room.changeset(attrs)
    |> Repo.update()
  end

  def insert_room(attrs \\ %{}) do
    %Room{}
    |> Room.changeset(attrs)
    |> Repo.insert()
  end

  def delete_room(%Room{} = room), do: Repo.delete(room)
end
