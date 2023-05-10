defmodule ChatAppWeb.SingleRoomLive do
  use ChatAppWeb, :live_view
  alias Bitwise
  alias Phoenix.PubSub
  alias ChatApp.LiveviewMonitor
  require Logger

  @impl true
  def mount(%{"id" => room_id}, _session, socket) do
    topic = "room:" <> room_id
    username = Faker.Person.name()
    if connected?(socket) do
      Logger.info("Liveview's second mount() call")
      LiveviewMonitor.monitor!(self(), __MODULE__, %{id: socket.id, room_id: room_id, username: username, users_typing: %{}})
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
    PubSub.broadcast(ChatApp.PubSub, "users_typing", {:users_typing, socket.assigns.username, true})
    {:noreply, socket}
  end

  def handle_event("user_typing_indication_ended", _, socket) do
    Logger.info("#{socket.assigns.username} is not typing anymore.")
    PubSub.broadcast(ChatApp.PubSub, "users_typing", {:users_typing, socket.assigns.username, false})
    {:noreply, socket}
  end

  @impl true
  def handle_info(:refresh_messages, socket) do
    updated_socket = assign(socket, messages: ChatApp.Contexts.Rooms.get_room_messages(socket.assigns.room_id))
    {:noreply, push_event(updated_socket, "new_message", %{id: "chatbox"})}
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

  def handle_info({:users_typing, username, status}, socket) do
    bool_as_int = fn x -> if x, do: 1, else: 0 end
    int_as_bool = fn x -> if x == 0, do: false, else: true end
    cond do
      socket.assigns.username == username -> {:noreply, socket}
      socket.assigns.username != username ->
        current_status = Map.get(socket.assigns.users_typing, username) |> bool_as_int.()
        updated_socket = assign(socket, users_typing: Map.put(socket.assigns.users_typing, username, status))
        sent_status = bool_as_int.(status)
        animation_condition = Bitwise.bxor(current_status, sent_status) |> int_as_bool.()
        if animation_condition do
          {:noreply, push_event(updated_socket, "animate_typing_indicator", %{id: "chatbox_anchor", status: status})}
        else
          {:noreply, updated_socket}
        end
    end
  end
end
