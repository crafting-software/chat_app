defmodule ChatApp.Room do
  @enforce_keys [:room_name, :owner_name, :current_participants, :max_participants, :expiry_timestamp]
  defstruct room_name: "", owner_name: "", current_participants: [], max_participants: 0, expiry_timestamp: DateTime.utc_now()

  def new(room_name, owner_name, max_participants, expiry_timestamp) do
    {
      Ecto.UUID.generate(),
      %__MODULE__{
        room_name: room_name,
        owner_name: owner_name,
        current_participants: [],
        max_participants: max_participants,
        expiry_timestamp: expiry_timestamp
      }
    }
  end

  @spec add_participant({Ecto.UUID, ChatApp.Room}, String.t()) :: {Ecto.UUID, ChatApp.Room}
  def add_participant(room, participant_name) do
    object = elem(room, 1)
    new_list_of_participants = [participant_name] ++ object.current_participants
    {
      elem(room, 0),
      object |> Map.put(:current_participants, new_list_of_participants)
    }
  end
end
