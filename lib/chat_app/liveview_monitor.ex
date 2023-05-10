defmodule ChatApp.LiveviewMonitor do
  use GenServer
  require Logger

  def start_link(args) do
    GenServer.start_link(__MODULE__, args, name: __MODULE__)
  end

  def init(_args) do
    {:ok, %{views: %{}}}
  end

  def monitor(pid, view_module, liveview_data) do
    case Process.whereis(__MODULE__) do
      nil -> raise RuntimeError, message: "Monitor process is not alive."
      monitor_pid -> GenServer.call(monitor_pid, {:monitor, pid, view_module, liveview_data})
    end
  end

  def handle_call({:monitor, pid, view_module, liveview_data}, _, state) do
    %{views: views} = state
    Logger.info("LiveviewMonitor started monitoring liveview with id #{liveview_data.id}.")
    Process.monitor(pid)
    {:reply, :ok, %{state | views: Map.put(views, pid, {view_module, liveview_data})}}
  end

  def handle_info({:DOWN, _ref, :process, pid, reason}, state) do
    Logger.info("LiveviewMonitor detected an exit event from liveview with id #{Map.get(state.views, pid) |> elem(1) |> Map.get(:id)}.")
    {{module, liveview_data}, new_views} = Map.pop(state.views, pid)
    module.unmount(liveview_data, reason)
    {:noreply, %{state | views: new_views}}
  end
end
