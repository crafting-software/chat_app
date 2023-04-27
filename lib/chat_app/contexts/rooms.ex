defmodule ChatApp.Contexts.Rooms do
  @adapter ChatApp.DatabaseAdapter
  alias ChatApp.Structs.Room

  def to_record(%ChatApp.Structs.Room{
        id: id,
        room_name: room_name,
        owner_name: owner_name,
        current_participants: current_participants,
        max_participants: max_participants,
        expiry_timestamp: expiry_timestamp
      }) do
    {id, room_name, owner_name, current_participants, max_participants, expiry_timestamp}
  end

  def from_record([
        {id, room_name, owner_name, current_participants, max_participants, expiry_timestamp}
      ]) do
    %ChatApp.Structs.Room{
      id: id,
      room_name: room_name,
      owner_name: owner_name,
      current_participants: current_participants,
      max_participants: max_participants,
      expiry_timestamp: expiry_timestamp
    }
  end

  def list_rooms(), do: @adapter.get_all(Room) |> Enum.map(fn row -> from_record([row]) end)

  def get_room(id), do: @adapter.get(Room, id) |> from_record()

  def update_room(
        %ChatApp.Structs.Room{
          id: _,
          room_name: _,
          owner_name: _,
          current_participants: _,
          max_participants: _,
          expiry_timestamp: _
        } = room
      ) do
    case @adapter.update(Room, to_record(room)) do
      true -> {:ok, room}
      _ -> {:error, "An error has occured."}
    end
  end

  def insert_room(
        %ChatApp.Structs.Room{
          id: _,
          room_name: _,
          owner_name: _,
          current_participants: _,
          max_participants: _,
          expiry_timestamp: _
        } = room
      ) do
    case @adapter.insert(Room, to_record(room)) do
      true -> {:ok, room}
      _ -> {:error, "An error has occured."}
    end
  end

  def delete_room(id) do
    case @adapter.delete(Room, id) do
      true -> {:ok, "Room deleted successfully."}
      _ -> {:error, "An error occured."}
    end
  end

  def room_exists?(id), do: @adapter.exists?(Room, id)
end
