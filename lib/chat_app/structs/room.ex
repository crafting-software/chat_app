defmodule ChatApp.Structs.Room do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:room_id, Ecto.UUID, autogenerate: true}

  schema "rooms" do
    field(:room_name, :string)
    field(:owner_name, :string)
    field(:current_participants, {:array, :string})
    field(:max_participants, :integer)
    field(:is_private, :boolean)
    field(:password, :string)
    field(:expiry_timestamp, :utc_datetime)

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
