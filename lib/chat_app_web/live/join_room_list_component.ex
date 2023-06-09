defmodule ChatAppWeb.JoinRoomListComponent do
  use ChatAppWeb, :live_component

  @doc """
  Usage in landing page:

  <.live_component module={ChatAppWeb.JoinRoomComponent} id="join-room-list-modal" />
  """

  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  def render(assigns) do
    ~H"""
    <div class="modal">
      <.modal id={"join-room-list-#{assigns.room_id}"}>
        <h2 class="join-room-modal-title">Join Room</h2>
        <form phx-submit="join_room">
          <div class="join-room-modal-form-group">
            <div class="join-room-modal-input-group">
              <input type="hidden" id={"room_id_at_creation-" <> assigns.room_id} name="room_id" value={assigns.room_id} />
              <label for="username">User Name:</label>
              <input type="text" id={"join_room_list_username-" <> assigns.room_id} name="username" required phx-hook="SetUsernameOnRoomJoinFromList"/>
            </div>
          </div>
          <div class="join-room-modal-button-group">
            <.button id={"room_list_join_button-" <> assigns.room_id} type="submit">Join</.button>
            <.button type="button" phx-click={hide_modal("join-room-list-#{assigns.room_id}")}>Cancel</.button>
          </div>
        </form>
      </.modal>
      <.link phx-click={show_modal("join-room-list-#{assigns.room_id}")}>Join</.link>
    </div>
    """
  end
end
