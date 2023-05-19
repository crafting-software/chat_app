defmodule ChatApp.Contexts.Reactions do
  alias ChatApp.Structs.Reaction
  alias ChatApp.Repo
  import Ecto.Query

  def get_reaction(id), do: Repo.get(Reaction, id)

  def insert_reaction(attrs \\ %{}) do
    %Reaction{}
    |> Reaction.changeset(attrs)
    |> Repo.insert()
  end

  def delete_reaction(reaction) do
    Reaction
    |> where([x], x.sender == ^reaction.sender and x.content == ^reaction.content and x.message_id == ^reaction.message_id)
    |> Repo.delete_all()
  end

  def create_reaction_as_map(content, shortcode, sender, message_id) do
    %{
      content: content,
      shortcode: shortcode,
      sender: sender,
      message_id: message_id
    }
  end
end
