defmodule ChatApp.Contexts.Messages do
  @adapter ChatApp.DatabaseAdapter
  alias ChatApp.Structs.Message

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

  def list_messages(), do: @adapter.get_all(Message) |> Enum.map(fn row -> from_record([row]) end)

  def get_message(id), do: @adapter.get(Message, id) |> from_record()

  def update_message(
        %ChatApp.Structs.Message{
          id: _,
          sender: _,
          content: _,
          room_id: _,
          timestamp: _,
          is_deleted: _
        } = message
      ) do
    case @adapter.update(Message, to_record(message)) do
      true -> {:ok, message}
      _ -> {:error, "An error has occured."}
    end
  end

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
    case @adapter.insert(Message, to_record(message)) do
      true -> {:ok, message}
      _ -> {:error, "An error has occured."}
    end
  end

  def delete_message(message), do: @adapter.delete(Message, message)

  def message_exists?(id), do: @adapter.exists?(Message, id)
end
