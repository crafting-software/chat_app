defmodule ChatAppWeb.SingleRoomLive do
  use ChatAppWeb, :live_view
  alias Phoenix.PubSub

  @impl true
  def mount(%{"id" => room_id}, _session, socket) do
    topic = "room:" <> room_id
    PubSub.subscribe(ChatApp.PubSub, topic)
    room = {room_id, "Room #0", "John Doe", 10, 300}
    {:ok, assign(socket, room: room, topic: topic, messages: [])}
  end

  @impl true
  def handle_params(%{"id" => _room_id}, _url, socket) do
    {:noreply, socket}
  end

  @impl true
  def handle_event("save_message", %{"text" => new_message_text}, socket) do
    {room_id, _, _, _, _} = socket.assigns.room
    topic = "room:" <> room_id
    broadcasted_message = {:update_messages, wrap_message_into_a_map(new_message_text)}
    PubSub.broadcast(ChatApp.PubSub, topic, broadcasted_message)
    {:noreply, socket}
  end

  @impl true
  def handle_info({:update_messages, new_message}, socket) do
    {:noreply, assign(socket, messages: [new_message | socket.assigns.messages])}
  end

  defp wrap_message_into_a_map(text) do
    %{
      text: text,
      datetime_as_string: get_datetime_as_string()
    }
  end

  defp get_datetime_as_string() do
    DateTime.utc_now()
    |> DateTime.truncate(:second)
    |> DateTime.to_string()
    |> String.slice(0..-2)
  end
end
