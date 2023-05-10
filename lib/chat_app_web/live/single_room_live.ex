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

      message = %{
        "content" => "anon joined the chat",
        "sender" => "",
        "room_id" => room_id,
        "timestamp" => DateTime.utc_now(),
        "is_deleted" => false,
        "is_edited" => false,
        "seq_number" => 0
      }

      IO.inspect(socket.assigns)

      broadcasted_message = {:add_messages, message}

      PubSub.broadcast(ChatApp.PubSub, topic, broadcasted_message)
    else
      Logger.info("Liveview's first mount() call")
    end

    room = ChatApp.Contexts.Rooms.get_room(room_id)

    {:ok,
     assign(socket,
       room_id: room_id,
       room: room,
       topic: topic,
       messages: Enum.reverse(ChatApp.Contexts.Rooms.get_room_messages(room_id)),
       users: ChatApp.Contexts.Rooms.get_room_users(room_id)
     )}
  end

  def unmount(%{id: liveview_id, room_id: room_id}, _reason) do
    message = %{
      "content" => "anon left the chat",
      "sender" => "",
      "room_id" => room_id,
      "timestamp" => DateTime.utc_now(),
      "is_deleted" => false,
      "is_edited" => false,
      "seq_number" => 1
    }

    broadcasted_message = {:add_messages, message}
    PubSub.broadcast(ChatApp.PubSub, "room:" <> room_id, broadcasted_message)
    IO.inspect broadcasted_message, label: "Broadcasted exit message"
    Logger.info("Liveview broadcasted exit message in room #{room_id} with liveview id #{liveview_id}.")
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
        message = %{
          "content" => new_message_text,
          "sender" => "anon",
          "room_id" => socket.assigns.room_id,
          "timestamp" => DateTime.utc_now(),
          "is_deleted" => false,
          "is_edited" => false,
          "seq_number" => 0
        }

        broadcasted_message =
           {:add_messages, message}

        PubSub.broadcast(ChatApp.PubSub, socket.assigns.topic, broadcasted_message)
        {:noreply, socket}

      _ ->
        {:noreply, socket}
    end
  end

  def handle_event("delete_message", %{"id" => message_id_from_client}, socket) do
    IO.puts(message_id_from_client)
    broadcasted_message = {:delete_messages, message_id_from_client}
    PubSub.broadcast(ChatApp.PubSub, socket.assigns.topic, broadcasted_message)
    {:noreply, socket}
  end

  @impl true
  def handle_info({:add_messages, new_message}, socket) do
    Logger.info("Liveview received an :add_messages broadcast: #{new_message["content"]}")
    {:ok, message} = ChatApp.Contexts.Messages.insert_message(new_message)
    {:noreply, assign(socket, messages: [message | socket.assigns.messages])}
  end

  def handle_info({:delete_messages, message_id_from_client}, socket) do
    {:noreply,
     assign(socket,
       messages:
         Enum.map(socket.assigns.messages, fn {message_id, message} ->
           cond do
             message_id == message_id_from_client ->
               {message_id, %{message | is_deleted: true}}

             true ->
               {message_id, message}
           end
         end)
     )}
  end
end
