defmodule ChatApp.Contexts.Messages do
  def to_record(%ChatApp.Structs.Message{
        id: id,
        sender: sender,
        content: content,
        room_id: room_id,
        timestamp: timestamp,
        is_deleted: is_deleted
      }) do
    {id, sender, content, room_id, timestamp, is_deleted}
  end

  def from_record([{id, sender, content, room_id, timestamp, is_deleted}]) do
    %ChatApp.Structs.Message{
      id: id,
      sender: sender,
      content: content,
      room_id: room_id,
      timestamp: timestamp,
      is_deleted: is_deleted
    }
  end

  def list_messages(), do: :ets.tab2list(:messages) |> Enum.map(fn row -> from_record([row]) end)

  def get_message(id), do: :ets.lookup(:messages, id) |> from_record()

  def insert_message(
        %ChatApp.Structs.Message{
          id: _,
          sender: _,
          content: _,
          room_id: _,
          timestamp: _,
          is_deleted: _
        } = message
      ) do
    case :ets.insert_new(:messages, to_record(message)) do
      true -> {:ok, message}
    end
  end

  def delete_message(message), do: :ets.delete(:messages, message)

  def message_exists?(id), do: :ets.member(:messages, id)
end
