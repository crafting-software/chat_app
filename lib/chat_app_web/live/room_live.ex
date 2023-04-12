defmodule ChatAppWeb.RoomLive do
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  def render(assigns) do
    ~H"""
    <.modal id="new-room-modal">
    <h2 id="new-room-modal-title">Create New Room</h2>
    <form phx-submit="create_room">
      <div class="form-group">
        <label for="room-name">Room Name:</label>
        <input type="text" id="room-name" name="room_name" required />
        <label for="user-name">User Name:</label>
        <input type="text" id="user-name" name="user_name" required />
        <input type="checkbox" id="is_public" name="is_public" required />
        <label for="is_public">Private
        <label for="password">Password:</label>
        <input type="password" id="password" name="password" required />
      </div>
      <br>
      <div class="button-group">
        <.button type="submit">Create Room</.button>
        <.button type="button" phx-click="hide_modal">Cancel</.button>
      </div>
    </form>
    </.modal>
    """
  end

  def handle_event("create_room", %{"room_name" => room_name, "user_name" => user_name, "is_public" => is_public, "password" => password}, socket) do

    #TODO: change room creation according to global rule
    room =
      {UUID.uuid4(), room_name,
       %{
         :max_size => 20,
         :current_size => 1,
         :lifetime => 12,
         :create_time => DateTime.utc_now()
         :is_public => is_public
         :password => password
       }, [user_name]}

    :ets.insert_new(:rooms, room)

    {:noreply, socket |> push_redirect(to: "/room/#{elem(room, 0)}")}
  end
end
