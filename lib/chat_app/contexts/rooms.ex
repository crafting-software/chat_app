defmodule ChatApp.Contexts.Rooms do
  alias ChatApp.Structs.Room
  alias ChatApp.Repo

  def list_rooms(), do: Repo.all(Room)

  def get_room(id), do: Repo.get(Room, id)

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
