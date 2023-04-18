defmodule ChatApp.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    database_module = Application.fetch_env!(:chat_app, :database_module)
    database_module_children =
      case database_module do
        ChatApp.PostgresRepo -> [ChatApp.Repo, Supervisor.child_spec({ChatApp.DatabaseManager, [database_module]}, id: SomeModule)]
        _ -> [Supervisor.child_spec({ChatApp.DatabaseManager, [database_module]}, id: SomeModule)]
      end

    children = [
      # Start the Telemetry supervisor
      ChatAppWeb.Telemetry,
      # Start the PubSub system
      {Phoenix.PubSub, name: ChatApp.PubSub},
      # Start Finch
      {Finch, name: ChatApp.Finch},
      # Start the Endpoint (http/https)
      ChatAppWeb.Endpoint
      # Start a worker by calling: ChatApp.Worker.start_link(arg)
      # {ChatApp.Worker, arg}
    ] ++ database_module_children

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
end
