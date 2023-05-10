defmodule ChatApp.Contexts.Rooms do
  alias ChatApp.Structs.Room
  alias ChatApp.Repo

  def list_rooms(), do: Repo.all(Room) |> Repo.preload([:messages, :users])

  def get_room(id), do: Repo.get(Room, id)

  def get_room_messages(id) do
    room = Repo.get(Room, id) |> Repo.preload([:messages])
    room.messages
  end

  def get_room_users(id) do
    room = Repo.get(Room, id) |> Repo.preload([:users])
    room.users
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
