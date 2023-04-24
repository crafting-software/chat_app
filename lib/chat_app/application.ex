defmodule ChatApp.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      # Start the Telemetry supervisor
      ChatAppWeb.Telemetry,
      # Start the Ecto repository
      ChatApp.Repo,
      # Start the PubSub system
      {Phoenix.PubSub, name: ChatApp.PubSub},
      # Start Finch
      {Finch, name: ChatApp.Finch},
      # Start the Endpoint (http/https)
      ChatAppWeb.Endpoint,
      # Start the Liveview monitor which will support the room disconnect message broadcast feature.
      {ChatApp.LiveviewMonitor, []}
      # Start a worker by calling: ChatApp.Worker.start_link(arg)
      # {ChatApp.Worker, arg}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: ChatApp.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    ChatAppWeb.Endpoint.config_change(changed, removed)
    :ok
  end

  @impl true
  def start_phase(:create_tables, :normal, _options) do
    IO.puts "START PHASE CREATE_TABLES"
    :ets.new(:rooms, [:set, :protected, :named_table])
    :ets.new(:messages, [:set, :protected, :named_table])
    :ok
  end

  @impl true
  def start_phase(:add_dummy_users, :normal, _options) do
    IO.puts "START PHASE ADD_DUMMY_USERS"
    dummy_room =
      ChatApp.Room.new("some_room", "John Doe", 10, DateTime.add(DateTime.utc_now(), 30, :minute))
      |> ChatApp.Room.add_participant("John Doe")
      |> ChatApp.Room.add_participant("Jennie Doe")
      |> ChatApp.Room.add_participant("Jamil Doe")
      |> ChatApp.Room.add_participant("James Doe")
      |> ChatApp.Room.add_participant("Jambalee Doe")
      |> ChatApp.Room.add_participant("Jeremiah Doe")
      |> ChatApp.Room.add_participant("Jimmy Doe")
      |> ChatApp.Room.add_participant("Jumbo Doe")
      |> ChatApp.Room.add_participant("Jeleu Doe")
    IO.inspect dummy_room, label: "Dummy room"
    :ets.insert(:rooms, dummy_room)
    :ok
  end
end
