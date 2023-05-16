defmodule ChatAppWeb.HomeLive do
  use ChatAppWeb, :live_view

  def mount(_params, _session, socket) do
    rooms = ChatApp.Contexts.Rooms.list_rooms()
    |> Enum.filter(fn room -> not room.is_private end)

    socket = assign(socket, :rooms, rooms)
    {:ok, socket}
  end

  def render(assigns) do
    ~H"""
    <div class="flex flex-col flex-1 h-full">
      <div>
        <.header>Public Rooms</.header>
        <.live_component module={ChatAppWeb.RoomComponent} id="modal" />
      </div>

      <div id="container" class="overflow-y-auto w-full mt-8">
        <div id="divrooms" class="overflow-y-auto w-full">
          <.table id="rooms" rows={@rooms}>
            <:col :let={room} label="Name"><%= room.room_name %></:col>
            <:col :let={room} label="Max nr of participants"><%= room.max_participants %></:col>
            <:action>
              <.link method="join">
                Join
              </.link>
            </:action>
          </.table>
        </div>
        <div id="gradient"></div>
      </div>

      <form>
        <.input id="roomcode" name="roomcode" value="" placeholder="room code here" />
        <.button id="join">Join</.button>
      </form>

      <div class="drawing">
        <div class="draw" id="downleft"></div>
        <div class="draw" id="upright"></div>
      </div>
    </div>
    """
  end

  def handle_event(
        "create_room",
        %{
          "room_name" => room_name,
          "owner_name" => owner_name,
          "max_participants" => max_participants,
          "password" => password
        } = params,
        socket
      ) do
    is_private_room = Map.get(params, "is_private") == "on"

    room = %{
      "room_name" => room_name,
      "owner_name" => owner_name,
      "max_participants" => max_participants,
      "is_private" => is_private_room,
      "password" => password,
      "expiry_timestamp" => DateTime.utc_now() |> DateTime.add(12, :hour)
    }

    {:ok, result} = ChatApp.Contexts.Rooms.insert_room(room)

    user = %{
      "username" => owner_name,
      "room_id" => result.id
    }

    {:ok, _} = ChatApp.Contexts.Users.insert_user(user)

    {:noreply, socket |> push_navigate(to: "/rooms/#{result.id}")}
  end
end
