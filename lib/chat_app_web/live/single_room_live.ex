defmodule ChatAppWeb.SingleRoomLive do
  use ChatAppWeb, :live_view
  alias Phoenix.PubSub
  alias ChatApp.LiveviewMonitor
  require Logger

  @impl true
  def mount(%{"id" => room_id}, _session, socket) do
    topic = "room:" <> room_id
    username = Faker.Person.name()
    if connected?(socket) do
      Logger.info("Liveview's second mount() call")
      LiveviewMonitor.monitor(self(), __MODULE__, %{id: socket.id, room_id: room_id, username: username, users_typing: %{}})
      PubSub.subscribe(ChatApp.PubSub, topic)
      PubSub.subscribe(ChatApp.PubSub, "users_typing")

      message = ChatApp.Contexts.Messages.create_message_as_map("#{username} joined the chat", "", room_id)
      ChatApp.Contexts.Messages.insert_message(message)
      PubSub.broadcast(ChatApp.PubSub, topic, :refresh_messages)
    else
      Logger.info("Liveview's first mount() call")
    end

    room = ChatApp.Contexts.Rooms.get_room(room_id)

    {:ok,
     assign(socket,
       room_id: room_id,
       room: room,
       topic: topic,
       messages: ChatApp.Contexts.Rooms.get_room_messages(room_id),
       users: ChatApp.Contexts.Rooms.get_room_users(room_id),
       username: username,
       users_typing: %{}
     )}
  end

  def unmount(%{id: liveview_id, room_id: room_id, username: username}, _reason) do
    message = ChatApp.Contexts.Messages.create_message_as_map("#{username} left the chat", "", room_id)
    ChatApp.Contexts.Messages.insert_message(message)
    PubSub.broadcast(ChatApp.PubSub, "room:" <> room_id, :refresh_messages)

    Logger.info(
      "Liveview broadcasted exit message in room #{room_id} with liveview id #{liveview_id}."
    )

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
        message = ChatApp.Contexts.Messages.create_message_as_map(new_message_text, "anon", socket.assigns.room_id)
        ChatApp.Contexts.Messages.insert_message(message)
        PubSub.broadcast(ChatApp.PubSub, socket.assigns.topic, :refresh_messages)
        {:noreply, socket}
      _ ->
        {:noreply, socket}
    end
  end

  def handle_event("delete_message", %{"id" => message_id_from_client}, socket) do
    deleted_message = ChatApp.Contexts.Messages.get_message(message_id_from_client)
    ChatApp.Contexts.Messages.update_message(deleted_message, %{is_deleted: true})

    broadcasted_message = {:delete_messages, message_id_from_client}
    PubSub.broadcast(ChatApp.PubSub, socket.assigns.topic, broadcasted_message)
    {:noreply, socket}
  end

  def handle_event("user_typing_indication", _, socket) do
    Logger.info("#{socket.assigns.username} is typing...")
    PubSub.broadcast(ChatApp.PubSub, "users_typing", {:users_typing, socket.assigns.username})
    {:noreply, socket}
  end

  def handle_event("user_typing_indication_ended", _, socket) do
    Logger.info("#{socket.assigns.username} is not typing anymore.")
    PubSub.broadcast(ChatApp.PubSub, "users_typing", {:users_typing_end, socket.assigns.username})
    {:noreply, socket}
  end

  @impl true
  def handle_info(:refresh_messages, socket) do
    {:noreply,
     assign(socket, messages: ChatApp.Contexts.Rooms.get_room_messages(socket.assigns.room_id))}
  end

  def handle_info({:delete_messages, message_id_from_client}, socket) do
    {:noreply,
     assign(socket,
       messages:
         Enum.map(socket.assigns.messages, fn message ->
          if message.id == message_id_from_client do
            %{message | is_deleted: true}
          else
            message
          end
        end)
     )}
  end

  def handle_info({:users_typing, username}, socket) do
    cond do
      socket.assigns.username == username -> {:noreply, socket}
      true -> {:noreply, assign(socket, users_typing: Map.put(socket.assigns.users_typing, username, true))}
    end
  end

  def handle_info({:users_typing_end, username}, socket) do
    cond do
      socket.assigns.username == username -> {:noreply, socket}
      true -> {:noreply, assign(socket, users_typing: Map.put(socket.assigns.users_typing, username, false))}
    end
  end

end
