defmodule ChatApp.Structs.Room do
  defstruct id: nil,
            room_name: "",
            owner_name: "",
            current_participants: [],
            max_participants: nil,
            is_private: "",
            password: "",
            expiry_timestamp: nil

  def schema_name, do: :rooms
end
