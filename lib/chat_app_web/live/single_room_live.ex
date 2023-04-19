defmodule ChatAppWeb.SingleRoomLive do
  use ChatAppWeb, :live_view
  alias Phoenix.PubSub

  @impl true
  def mount(%{"id" => room_id}, _session, socket) do
    topic = "room:" <> room_id
    PubSub.subscribe(ChatApp.PubSub, topic)
    [{room_id, room}] = :ets.lookup(:rooms, room_id)
    new_socket =
      socket
      |> assign(room_id: room_id)
      |> assign(room: room)
      |> assign(topic: topic)
      |> assign(messages: [])
      |> assign(users: room.current_participants)
    {:ok, new_socket}
  end

  @impl true
  def handle_params(%{"id" => _room_id}, _url, socket) do
    {:noreply, socket}
  end

  @impl true
  def handle_event("save_message", %{"text" => new_message_text}, socket) do
    case Regex.match?(~r/^ *$/, new_message_text) do
      false ->
        broadcasted_message = {:update_messages, wrap_message_into_a_map(new_message_text)}
        PubSub.broadcast(ChatApp.PubSub, socket.assigns.topic, broadcasted_message)
        {:noreply, socket}
      _ -> {:noreply, socket}
    end
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
