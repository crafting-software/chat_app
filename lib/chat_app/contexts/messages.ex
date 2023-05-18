defmodule ChatApp.Contexts.Messages do
  alias ChatApp.Structs.Message
  alias ChatApp.Repo

  def get_message(id), do: Repo.get(Message, id) |> Repo.preload([:reactions])

  def update_message(%Message{} = message, attrs) do
    message
    |> Message.changeset(attrs)
    |> Repo.update()
  end

  def insert_message(attrs \\ %{}) do
    %Message{}
    |> Message.changeset(attrs)
    |> Repo.insert()
  end

  def insert_message_reaction(%Message{} = message, reaction) do
    IO.inspect reaction, label: "Reaction from the context"
    message
    |> Ecto.Changeset.change()
    |> Ecto.Changeset.put_assoc(:reactions, [reaction | message.reactions])
    |> Repo.update()
  end

  def delete_message(%Message{} = message), do: Repo.delete(message)

  def create_message_as_map(content, sender, room_id) do
    %{
      "content" => content,
      "sender" => sender,
      "room_id" => room_id,
      "is_deleted" => false,
      "is_edited" => false
    }
  end
end
