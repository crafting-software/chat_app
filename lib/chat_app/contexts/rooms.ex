defmodule ChatApp.Contexts.Rooms do

  # protocols

  def to_record(
        %ChatApp.Structs.Room{
          id: id,
          room_name: room_name,
          owner_name: owner_name,
          current_participants: current_participants,
          max_participants: max_participants,
          expiry_timestamp: expiry_timestamp
        }
      ) do
    {id, room_name, owner_name, current_participants, max_participants, expiry_timestamp} |> IO.inspect()
  end

  def from_record([{id, room_name, owner_name, current_participants, max_participants, expiry_timestamp}]) do
    %ChatApp.Structs.Room{
      id: id,
      room_name: room_name,
      owner_name: owner_name,
      current_participants: current_participants,
      max_participants: max_participants,
      expiry_timestamp: expiry_timestamp
    }
  end

  def list_rooms() do
    rooms = :ets.tab2list(:rooms)
    Enum.map(rooms, fn row ->
      from_record([row])
    end)
  end

  def get_room(id) do
    room = :ets.lookup(:rooms, id)
    from_record(room)
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
        case :ets.insert_new(:rooms, to_record(room)) do
           true -> {:ok, room}
           false -> {:error, "The Room exists!"}

        end
  end

  def delete_room(room) do
    :ets.delete(:rooms, room)
  end

  def room_exists?(id) do
    :ets.member(:rooms, id)
  end
end
