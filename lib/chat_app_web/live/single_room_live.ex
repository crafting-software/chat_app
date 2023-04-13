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
    {:noreply, assign(socket, messages: [new_message | socket.assigns.messages])}
  end

  @impl true
  def handle_info({:update_messages, new_message}, socket) do
    {:noreply, assign(socket, messages: [new_message | socket.assigns.messages])}
  end

  @impl true
  def render(assigns) do
    ~H"""
    <.header>
      Room "<%= @room |> elem(1) %>"
      <%!--
      <:actions>
        <.link patch={~p"/rooms/#{@room}/show/edit"} phx-click={JS.push_focus()}>
          <.button>Edit room</.button>
        </.link>
      </:actions>
      --%>
    </.header>

    <div class="object-fill h-96 border-2 border-gray-900">
      <ul>
        <%= for message <- @messages do %>
          <li title="anon">anon: <%= message %></li>
        <% end %>
      </ul>
    </div>

    <form action="#" phx-submit="save_message">
      <input name="text" class="rounded-md border-4 border-gray-900"/>
      <button type="submit" class="rounded-md text-white bg-blue-500 hover:bg-blue-300">Send</button>
    </form>

    <.back navigate={~p"/rooms"}>Back to room list</.back>
    <%!--
    <.modal :if={@live_action == :edit} id="room-modal" show on_cancel={JS.patch(~p"/rooms/#{@room}")}>
      <.live_component
        module={UltraoriginalChattyChatAppWeb.RoomLive.FormComponent}
        id={@room.id}
        title={@page_title}
        action={@live_action}
        room={@room}
        patch={~p"/rooms/#{@room}"}
      />
    </.modal>
    --%>
    """
  end
end
