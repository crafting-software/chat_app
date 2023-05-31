defmodule ChatAppWeb.JoinRoomByLinkComponent do
  use ChatAppWeb, :live_component

  @doc """
  Usage in landing page:

  <.live_component module={ChatAppWeb.JoinRoomByLinkComponent} id="join-room-by-link-modal" />
  """

  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  def render(assigns) do
    ~H"""
    <div class="modal" phx-mounted={true && show_modal("join-room-by-link-modal")}>
      <.modal id="join-room-by-link-modal">
        <h2 class="join-room-modal-title">Join Room</h2>
        <form phx-submit="join_room">
          <div class="join-room-modal-form-group">
            <div class="join-room-modal-input-group">
              <input
                type="hidden"
                id={"room_id_at_creation-" <> assigns.room_id}
                name="room_id"
                value={assigns.room_id}
              />
              <label for="username">User Name:</label>
              <input
                type="text"
                id="join_room_username"
                name="username"
                required
                phx-hook="SetUsernameOnRoomJoinThroughLink"
              />
            </div>
          </div>
          <div class="join-room-modal-button-group">
            <.button id="room_join_button" type="submit">Join</.button>
            <.button type="button" phx-click={hide_modal("join-room-modal")}>Cancel</.button>
          </div>
        </form>
      </.modal>
    </div>
    """
  end
end
