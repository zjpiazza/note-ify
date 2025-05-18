defmodule NoteIfyWeb.PageController do
  use NoteIfyWeb, :controller

  def home(conn, _params) do
    if conn.assigns[:current_user] do
      redirect(conn, to: "/dashboard")
    else
      # Data for the marketing home page
      sample_postcard = %{
        recipient: "Your Name Here",
        date: "May 10, 2025",
        summary_period: "MAY 3-9",
        alerts: [
          "web-server-01: CPU at 99% for 3 hours on May 4",
          "database-prod: Out of disk space on May 6",
          "load-balancer: Unreachable for 45 min on May 7"
        ]
      }

      render(conn, :home,
        page_title: "Prometheus Alerts Via Snail Mail",
        sample_postcard: sample_postcard,
        hide_sidebar: true
      )
    end
  end
end
