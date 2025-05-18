defmodule NoteIfyWeb.SettingsController do
  use NoteIfyWeb, :controller

  def index(conn, _params) do
    # Data needed for settings page
    user = %{
      name: "John Doe",
      email: "john@example.com",
      first_name: "John",
      last_name: "Doe",
      company: "Acme Inc.",
      phone: "+1 (555) 123-4567"
    }

    address = %{
      line1: "123 Main St",
      line2: "Apt 4B",
      city: "New York",
      state: "NY",
      postal_code: "10001",
      country: "us",
      delivery_instructions: "Leave with doorman"
    }

    preferences = %{
      weekly_summaries: true,
      monthly_summaries: false,
      postcard_template: "classic",
      color_printing: true,
      critical_alerts_only: false,
      include_resolved_alerts: true
    }

    render(conn, :index,
      page_title: "Settings",
      user: user,
      address: address,
      preferences: preferences
    )
  end
end
