defmodule ChatApp.Contexts.Messages do
  alias ChatApp.Structs.Message
  alias ChatApp.Repo

  def get_message(id), do: Repo.get(Message, id)

  def update_message(%Message{} = message, attrs) do
    updated_message =
      message
      |> Message.changeset(attrs)
      |> Repo.update()
    updated_message
  end

  def insert_message(attrs \\ %{}) do
    %Message{}
    |> Message.changeset(attrs)
    |> Repo.insert()
  end

  def delete_message(%Message{} = message), do: Repo.delete(message)
end
