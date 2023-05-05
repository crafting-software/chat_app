defmodule ChatAppWeb.SingleRoomLive do
  use ChatAppWeb, :live_view
  alias Phoenix.PubSub
  alias ChatApp.LiveviewMonitor
  require Logger

  @impl true
  def mount(%{"id" => room_id}, _session, socket) do
    topic = "room:" <> room_id
    cond do
      connected?(socket) ->
        Logger.info("Liveview's second mount() call")
        LiveviewMonitor.monitor(self(), __MODULE__, %{id: socket.id, room_id: room_id})
        PubSub.subscribe(ChatApp.PubSub, topic)
        broadcasted_message = {:update_messages, %{text: "anon joined the chat.", datetime_as_string: ""}}
        PubSub.broadcast(ChatApp.PubSub, topic, broadcasted_message)
      true -> Logger.info("Liveview's first mount() call")
    end

    [{room_id, room}] = :ets.lookup(:rooms, room_id)
    {:ok, assign(socket, room_id: room_id, room: room, topic: topic, messages: [], users: room.current_participants)}
  end

  def unmount(%{id: _liveview_id, room_id: room_id}, reason) do
    broadcasted_message = {:update_messages, %{text: "anon left the chat.", datetime_as_string: ""}}
    PubSub.broadcast(ChatApp.PubSub, "room:" <> room_id, broadcasted_message)
    :ok
  end

  @impl true
  def handle_params(_params, _url, socket) do
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
