defmodule ChatApp.Structs.Message do
  defstruct id: nil, sender: "", content: "", room_id: nil, timestamp: nil, is_deleted: ""

  def schema_name, do: :messages
end
