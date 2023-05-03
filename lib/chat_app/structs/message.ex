defmodule ChatApp.Structs.Message do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:message_id, Ecto.UUID, autogenerate: true}

  schema "messages" do
    field(:sender, :string)
    field(:content, :string)
    field(:room_id, :integer)
    field(:timestamp, :utc_datetime)
    field(:is_deleted, :boolean)
    field(:is_edited, :boolean)

    timestamps()
  end

  def changeset(params \\ %{}) do
    changeset(%__MODULE__{}, params)
  end

  def changeset(model, params) do
    fields = __MODULE__.__schema__(:fields)
    embeds = __MODULE__.__schema__(:embeds)
    cast_model = cast(model, params, fields -- embeds)

    Enum.reduce(embeds, cast_model, fn embed, model ->
      cast_embed(model, embed)
    end)
  end
end
