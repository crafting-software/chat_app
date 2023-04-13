defmodule ChatAppWeb.SingleRoomLive do
  use ChatAppWeb, :live_view
  alias Phoenix.PubSub

  @impl true
  def mount(%{"id" => room_id}, _session, socket) do
    topic = "room:" <> room_id
    PubSub.subscribe(ChatApp.PubSub, topic)
    room = {room_id, "Room #0", "John Doe", 10, 300}
    {:ok, assign(socket, room: room, topic: topic, messages: ["hey buddy!"])}
  end

  @impl true
  def handle_params(%{"id" => _room_id}, _url, socket) do
    {:noreply, socket}
  end

  @impl true
  def handle_event("save_message", %{"text" => new_message}, socket) do
    {room_id, _, _, _, _} = socket.assigns.room
    topic = "room:" <> room_id
    PubSub.broadcast(ChatApp.PubSub, topic, {:update_messages, new_message})
    {:noreply, socket}
  end

  @impl true
  def handle_info({:update_messages, new_message}, socket) do
    {:noreply, assign(socket, messages: [new_message | socket.assigns.messages])}
  end
end
