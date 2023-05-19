defmodule ChatAppWeb.HomeLive do
  use ChatAppWeb, :live_view

  def mount(_params, _session, socket) do
    rooms =
      ChatApp.Contexts.Rooms.list_rooms()
      |> Enum.filter(fn room -> not room.is_private end)

    socket = assign(socket, :rooms, rooms)
    {:ok, socket}
  end

  def handle_params(_params, url, socket) do
    {:noreply, assign(socket, url: URI.parse(url))}
  end

  def render(assigns) do
    ~H"""
    <div class="flex flex-col flex-1 h-full">
      <div id="homepage_header">
        <.header>Public Rooms</.header>
        <div id="modals">
          <.live_component module={ChatAppWeb.RoomComponent} id="modal" />
          <.live_component module={ChatAppWeb.JoinRoomComponent} id="join-room-modal" />
        </div>
      </div>

      <div id="container" class="overflow-y-auto w-full mt-8">
        <div id="divrooms" class="overflow-y-auto w-full">
          <.table id="rooms" rows={@rooms}>
            <:col :let={room} label="Name"><%= room.room_name %></:col>
            <:col :let={room} label="Max nr of participants"><%= room.max_participants %></:col>
            <:action :let={room}>
              <.link phx-click={JS.push("join_room", value: %{room_id: room.id})} >Join</.link>
            </:action>
          </.table>
        </div>
        <div id="gradient"></div>
      </div>

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

  def handle_event(
        "join_room",
        %{
          "username" => username,
          "room_id" => room_id
        },
        socket
      ) do

    user = %{
      "username" => username,
      "room_id" => room_id
    }

    {:ok, _} = ChatApp.Contexts.Users.insert_user(user)

    {:noreply, socket |> push_navigate(to: "/rooms/#{room_id}")}
  end

  def handle_event("join_room", room_id, socket), do:
    username = show_modal("join-room-list-modal")
    user = %{
      "username" => username,
      "room_id" => room_id
    }

    {:ok, _} = ChatApp.Contexts.Users.insert_user(user)

    {:noreply, socket |> push_navigate(to: "/rooms/#{room_id}")}
end
# <.link phx-click={JS.push("show_modal("join-room-list-modal")", value: %{roomid: room.id})}>Join</.link>

# <p phx-click={JS.push("event_name", value: %{id: 1234}) |> show_modal("modal_id")}>open modal and send event</p>
# <.link phx-click={show_modal("join-room-list-modal")}>Join</.link>
