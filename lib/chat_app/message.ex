defmodule ChatApp.Message do
  @enforce_keys [:text, :sender, :room_id, :timestamp]
  defstruct text: "", sender: "", room_id: Ecto.UUID.generate(), timestamp: DateTime.utc_now(), is_deleted: false, is_edited: false

  def new(text, sender, room_id) do
    {
      Ecto.UUID.generate(),
      %__MODULE__{
        text: text,
        sender: sender,
        room_id: room_id,
        timestamp: DateTime.utc_now(),
        is_deleted: false,
        is_edited: false
      }
    }
  end
end
