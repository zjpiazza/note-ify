defmodule NoteIfy.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    unless Mix.env() == :prod do
      Dotenv.load()
      Mix.Task.run("loadconfig")
    end

    children = [
      NoteIfyWeb.Telemetry,
      {DNSCluster, query: Application.get_env(:note_ify, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: NoteIfy.PubSub},
      # Start the Finch HTTP client for sending emails
      {Finch, name: NoteIfy.Finch},
      # Start the Finch HTTP client for Clerk auth
      {Finch, name: ClerkHTTP},
      # Start to serve requests, typically the last entry
      NoteIfyWeb.Endpoint
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: NoteIfy.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    NoteIfyWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
