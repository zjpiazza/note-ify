defmodule NoteIfyWeb.Router do
  use NoteIfyWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, html: {NoteIfyWeb.Layouts, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug NoteIfyWeb.Plugs.AuthPlug
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  pipeline :authenticated do
    plug NoteIfyWeb.Plugs.EnsureAuthenticated
  end

  # Public routes available without authentication
  scope "/", NoteIfyWeb do
    pipe_through :browser

    get "/", PageController, :home

    # Auth routes
    get "/login", AuthController, :login
    get "/signup", AuthController, :signup
    get "/logout", AuthController, :logout
  end

  # Protected routes that require authentication
  scope "/", NoteIfyWeb do
    pipe_through [:browser, :authenticated]

    get "/dashboard", DashboardController, :index
    get "/billing", BillingController, :index
    get "/settings", SettingsController, :index
  end

  # API routes
  scope "/api", NoteIfyWeb do
    pipe_through :api
  end

  # Enable LiveDashboard and Swoosh mailbox preview in development
  if Application.compile_env(:note_ify, :dev_routes) do
    # If you want to use the LiveDashboard in production, you should put
    # it behind authentication and allow only admins to access it.
    # If your application does not have an admins-only section yet,
    # you can use Plug.BasicAuth to set up some basic authentication
    # as long as you are also using SSL (which you should anyway).
    import Phoenix.LiveDashboard.Router

    scope "/dev" do
      pipe_through :browser

      live_dashboard "/dashboard", metrics: NoteIfyWeb.Telemetry
      forward "/mailbox", Plug.Swoosh.MailboxPreview
    end
  end
end
