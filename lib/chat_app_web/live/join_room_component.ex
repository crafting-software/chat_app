defmodule ChatAppWeb.JoinRoomComponent do
  use ChatAppWeb, :live_component

  @doc """
  Usage in landing page:

  <.live_component module={ChatAppWeb.JoinRoomComponent} id="join-room-modal" />
  """

  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  def render(assigns) do
    ~H"""
    <div class="modal">
      <.modal id="join-room-modal">
        <h2 class="join-room-modal-title">Join Room</h2>
        <form phx-submit="join_room">
          <div class="join-room-modal-form-group">
            <div class="join-room-modal-input-group">
              <input type="text" id="room_id" name="room_id" value="" placeholder="room code here" />
              <label for="username">User Name:</label>
              <input type="text" id="username" name="username" required />
            </div>
          </div>
          <div class="join-room-modal-button-group">
            <.button type="submit">Join</.button>
            <.button type="button" phx-click={hide_modal("join-room-modal")}>Cancel</.button>
          </div>
        </form>
      </.modal>
      <.button id="join-room-button" phx-click={show_modal("join-room-modal")}>Join Room via Code</.button>
    </div>
    """
  end
end
