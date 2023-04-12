defmodule ChatApp.Room do
  @doc """
  Room module example for handling ETS Database calls

  More functions can be added, these ones are just what we need for now.
  """

  def list_rooms() do
    :ets.tab2list(:rooms)
  end

  def insert_room(room) do
    :ets.insert(:rooms, room)
  end

  def room_exists(id) do
    :ets.lookup(:rooms, id)
  end
end
