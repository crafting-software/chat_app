defmodule ChatAppWeb.SingleRoomLive do
  use ChatAppWeb, :live_view
  alias Bitwise
  alias Phoenix.PubSub
  alias ChatApp.LiveviewMonitor
  alias Faker
  require Logger

  @impl true
  def mount(%{"id" => room_id}, _session, socket) do
    messages_topic = "messages:room:" <> room_id
    typing_statuses_topic = "typing_statuses:room:" <> room_id
    username = Faker.Person.name()
    if connected?(socket) do
      Logger.info("Liveview's second mount() call")
      LiveviewMonitor.monitor!(self(), __MODULE__, %{id: socket.id, room_id: room_id, username: username, users_typing: MapSet.new()})
      PubSub.subscribe(ChatApp.PubSub, messages_topic)
      PubSub.subscribe(ChatApp.PubSub, typing_statuses_topic)

      message = ChatApp.Contexts.Messages.create_message_as_map("#{username} joined the chat", "", room_id)
      ChatApp.Contexts.Messages.insert_message(message)
      PubSub.broadcast(ChatApp.PubSub, messages_topic, :refresh_messages)
    else
      Logger.info("Liveview's first mount() call")
    end

    room = ChatApp.Contexts.Rooms.get_room(room_id)

    {:ok,
     assign(socket,
       room_id: room_id,
       room: room,
       messages: ChatApp.Contexts.Rooms.get_room_messages(room_id),
       messages_topic: messages_topic,
       typing_statuses_topic: typing_statuses_topic,
       users: ChatApp.Contexts.Rooms.get_room_users(room_id),
       username: username,
       users_typing: MapSet.new()
     )}
  end

  def unmount(%{id: liveview_id, room_id: room_id, username: username}, _reason) do
    message = ChatApp.Contexts.Messages.create_message_as_map("#{username} left the chat", "", room_id)
    ChatApp.Contexts.Messages.insert_message(message)
    PubSub.broadcast(ChatApp.PubSub, "typing_statuses:room:" <> room_id, {:users_typing, username, false})
    PubSub.broadcast(ChatApp.PubSub, "messages:room:" <> room_id, :refresh_messages)

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
        message = ChatApp.Contexts.Messages.create_message_as_map(new_message_text, socket.assigns.username, socket.assigns.room_id)
        ChatApp.Contexts.Messages.insert_message(message)
        PubSub.broadcast(ChatApp.PubSub, socket.assigns.messages_topic, :refresh_messages)
        {:noreply, socket}
      _ ->
        {:noreply, socket}
    end
  end

  def handle_event("delete_message", %{"id" => message_id_from_client}, socket) do
    deleted_message = ChatApp.Contexts.Messages.get_message(message_id_from_client)
    ChatApp.Contexts.Messages.update_message(deleted_message, %{is_deleted: true})

    broadcasted_message = {:delete_messages, message_id_from_client}
    PubSub.broadcast(ChatApp.PubSub, socket.assigns.messages_topic, broadcasted_message)
    {:noreply, socket}
  end

  def handle_event("user_typing_indication", _, socket) do
    Logger.info("#{socket.assigns.username} is typing...")
    PubSub.broadcast(ChatApp.PubSub, socket.assigns.typing_statuses_topic, {:users_typing, socket.assigns.username, true})
    {:noreply, socket}
  end

  def handle_event("user_typing_indication_ended", _, socket) do
    Logger.info("#{socket.assigns.username} is not typing anymore.")
    PubSub.broadcast(ChatApp.PubSub, socket.assigns.typing_statuses_topic, {:users_typing, socket.assigns.username, false})
    {:noreply, socket}
  end

  @impl true
  def handle_info(:refresh_messages, socket) do
    updated_socket = assign(socket, messages: ChatApp.Contexts.Rooms.get_room_messages(socket.assigns.room_id))
    {:noreply, push_event(updated_socket, "new_message", %{id: "chatbox"})}
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

  def handle_info({:users_typing, username, status}, socket) do
    case socket.assigns.username do
      ^username -> {:noreply, socket}
      _ ->
        current_status = MapSet.member?(socket.assigns.users_typing, username)
        animation_condition = current_status != status or current_status == status and current_status
        users_typing = socket.assigns.users_typing
        updated_typing_statuses = if not status, do: MapSet.delete(users_typing, username), else: MapSet.put(users_typing, username)
        updated_socket = assign(socket, users_typing: updated_typing_statuses)
        if animation_condition do
          {:noreply, push_event(updated_socket, "animate_typing_indicator", %{id: "chatbox_anchor", status: status})}
        else
          {:noreply, updated_socket}
        end
    end
  end
end
