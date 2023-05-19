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
      <.modal id="join-room-list-modal">
        <h2 id="join-room-modal-title">Join Room</h2>
        <form phx-value-username="username">
          <div class="join-room-modal-form-group">
            <div class="join-room-modal-input-group">
              <label for="username">User Name:</label>
              <input type="text" id="username" name="username" required />
            </div>
          </div>
          <div class="join-room-modal-button-group">
            <.button type="submit">Join</.button>
            <.button type="button" phx-click={hide_modal("join-room-list-modal")}>Cancel</.button>
          </div>
        </form>
      </.modal>
    </div>
    """
  end
end
