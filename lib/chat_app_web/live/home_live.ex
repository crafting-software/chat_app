defmodule ChatAppWeb.HomeLive do
  use ChatAppWeb, :live_view

  def mount(_params, _session, socket) do
    rooms = [%{id: 1, name: "room1", description: "capybara numero uno"}, %{id: 2, name: "room2", description: "capybara numero dos"}, %{id: 3, name: "room3", description: "capybara numero tres"}]
    socket = assign(socket, :rooms, rooms)
    {:ok, socket}
  end

  def render(assigns) do
    ~H"""
    <div class="hd">
    <.header class="hd">Public Rooms</.header>
    <.live_component module={ChatAppWeb.RoomComponent} id="modal" />
    </div>


    <.table id="rooms" rows={@rooms}>
      <:col :let={room}><%= room.id %></:col>
      <:col :let={room}><%= room.name %></:col>
      <:col :let={room}><%= room.description %></:col>
      <:action>
        <.link method="join" class="join_link">
          Join
        </.link>
      </:action>
    </.table>

    <form class="jn">
      <.input id="roomcode" name="roomcode" value="" placeholder="room code here"/>
      <.button id="join">Join</.button>
    </form>

    <div class="drawing">
      <div class="draw" id="jos"></div>
      <div class="draw" id="sus"></div>
    </div>
    """
  end
end
