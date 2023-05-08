defmodule ChatAppWeb.SingleRoomLive do
  use ChatAppWeb, :live_view
  alias Phoenix.PubSub
  alias ChatApp.LiveviewMonitor
  require Logger

  @impl true
  def mount(%{"id" => room_id}, _session, socket) do
    topic = "room:" <> room_id
    if connected?(socket) do
        Logger.info("Liveview's second mount() call")
        LiveviewMonitor.monitor(self(), __MODULE__, %{id: socket.id, room_id: room_id})
        PubSub.subscribe(ChatApp.PubSub, topic)
        broadcasted_message = {:add_messages, ChatApp.Message.new("anon joined the chat.", "", room_id)}
        PubSub.broadcast(ChatApp.PubSub, topic, broadcasted_message)
    else
       Logger.info("Liveview's first mount() call")
    end

    room = ChatApp.Contexts.Rooms.get_room(room_id)
    {:ok, assign(socket, room_id: room.id, room: room, topic: topic, messages: [], users: ChatApp.Contexts.Rooms.get_room_users(room.id).users, current_message: "")}
  end

  def unmount(%{id: _liveview_id, room_id: room_id}, _reason) do
    broadcasted_message = {:add_messages, ChatApp.Message.new("anon left the chat.", "", room_id)}
    PubSub.broadcast(ChatApp.PubSub, "room:" <> room_id, broadcasted_message)
    :ok
  end

  @impl true
  def handle_params(_params, _url, socket) do
    {:noreply, socket}
  end

  @impl true
  def handle_event("save_message", %{"text" => new_message_text}, socket) do
    case Regex.match?(~r/^\s*$/, new_message_text) do
      false ->
        broadcasted_message = {:add_messages, ChatApp.Message.new(new_message_text, "anon", socket.assigns.room_id)}
        PubSub.broadcast(ChatApp.PubSub, socket.assigns.topic, broadcasted_message)
        {:noreply, socket}
      _ -> {:noreply, socket}
    end
  end

  def handle_event("delete_message", %{"id" => message_id_from_client}, socket) do
    IO.puts message_id_from_client
    broadcasted_message = {:delete_messages, message_id_from_client}
    PubSub.broadcast(ChatApp.PubSub, socket.assigns.topic, broadcasted_message)
    {:noreply, socket}
  end

  @impl true
  def handle_info({:add_messages, new_message}, socket) do
    {:noreply, assign(socket, messages: [new_message | socket.assigns.messages])}
  end

  def handle_info({:delete_messages, message_id_from_client}, socket) do
    {:noreply, assign(socket, messages: Enum.map(socket.assigns.messages, fn {message_id, message} ->
      cond do
        message_id == message_id_from_client ->
          {message_id, %{message | is_deleted: true}}
        true ->
          {message_id, message}
      end
    end))}
  end

  defp get_datetime_as_string() do
    [date_as_string, time_as_string] =
      DateTime.utc_now()
      |> DateTime.truncate(:second)
      |> DateTime.to_string()
      |> String.slice(0..-2)
      |> String.split(" ")

    [year_as_string, month_as_string, day_as_string] = String.split(date_as_string, "-")
    date_in_new_format = day_as_string <> "/" <> month_as_string <> "/" <> year_as_string
    date_in_new_format <> " " <> time_as_string
  end
end
