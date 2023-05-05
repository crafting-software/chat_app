defmodule ChatAppWeb.RoomComponent do
  use ChatAppWeb, :live_component

  @doc """
  Usage in landing page:

  <.live_component module={ChatAppWeb.RoomComponent} id="modal" />
  """

  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  def render(assigns) do
    ~H"""
    <div class="modal">
    <.modal id="new-room-modal">
    <h2 id="new-room-modal-title">Create New Room</h2>
    <form phx-submit="create_room">
    <div class="room-modal-form-group">
        <div class="room-modal-input-group">
        <label for="room-name">Room Name:</label>
        <input type="text" id="room-name" name="room_name" required />
        </div>
        <div class="room-modal-input-group">
        <label for="user-name">User Name:</label>
        <input type="text" id="user-name" name="user_name" required />
        </div>
        <div class="room-modal-checkbox-group">
        <label for="is_public">Private Room:</label>
        <input type="checkbox" id="is_public" name="is_public" />
        </div>
        <div class="room-modal-input-group">
        <label for="password" id="password-label" class="hidden">Password:</label>
        <input type="password" id="password-input" class="hidden" name="password" required/>
        </div>
      </div>
      <div class="room-modal-button-group">
        <.button type="submit">Create Room</.button>
        <.button type="button" phx-click={hide_modal("new-room-modal")}>Cancel</.button>
      </div>
    </form>
    </.modal>
    <.button id="new-room-button" phx-click={show_modal("new-room-modal")}>New Room</.button>
    </div>
    """
  end
end
