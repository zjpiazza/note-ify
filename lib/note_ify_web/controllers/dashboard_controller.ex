defmodule NoteIfyWeb.DashboardController do
  use NoteIfyWeb, :controller

  def index(conn, _params) do
    # Use the current user from conn.assigns (set by AuthPlug)
    current_user = conn.assigns.current_user

    # Data needed for dashboard
    user = %{
      name: "#{current_user.first_name} #{current_user.last_name}",
      email: current_user.email,
      next_postcard_date: "May 24, 2025"
    }

    stats = %{
      total_alerts: 1284,
      alerts_increase: "+24%",
      postcards_sent: 12,
      postcards_scheduled: 3,
      active_webhooks: 3,
      webhooks_with_alerts: 2,
      delivery_rate: "98.2%",
      delivery_change: "+0.5%"
    }

    alerts = [
      %{
        title: "High CPU Usage",
        severity: "critical",
        description: "CPU usage above 95% for more than 5 minutes",
        source: "web-server-01",
        time: "2 minutes ago"
      },
      %{
        title: "Memory Low",
        severity: "warning",
        description: "Available memory below 10%",
        source: "api-server",
        time: "15 minutes ago"
      },
      %{
        title: "Database Connection Failed",
        severity: "critical",
        description: "Unable to connect to database after 5 retries",
        source: "postgres-main",
        time: "32 minutes ago"
      },
      %{
        title: "High Latency",
        severity: "warning",
        description: "API response time above 500ms",
        source: "auth-service",
        time: "1 hour ago"
      },
      %{
        title: "Disk Space Low",
        severity: "warning",
        description: "Available disk space below 15%",
        source: "storage-server",
        time: "2 hours ago"
      },
      %{
        title: "Service Restart",
        severity: "info",
        description: "Service automatically restarted",
        source: "notification-service",
        time: "3 hours ago"
      }
    ]

    recent_activities = [
      %{
        icon: "📬",
        description: "Postcard for week of May 10-16 has been delivered",
        time: "Today at 10:23 AM"
      },
      %{
        icon: "🔌",
        description: "New webhook endpoint created for 'Production API'",
        time: "Yesterday at 4:15 PM"
      },
      %{icon: "💳", description: "Billing information updated", time: "May 15 at 2:30 PM"},
      %{
        icon: "📮",
        description: "Postcard for week of May 3-9 has been mailed",
        time: "May 10 at 9:00 AM"
      },
      %{
        icon: "⭐",
        description: "Subscription upgraded to 'Express Mail' plan",
        time: "May 5 at 11:45 AM"
      }
    ]

    next_postcard = %{
      to: "John Doe",
      date: "May 24, 2025",
      summary_period: "MAY 17-23",
      alerts: [
        "web-server-01: High CPU Usage (95%+)",
        "postgres-main: Database Connection Failed",
        "api-server: Memory Low (10%)",
        "auth-service: High Latency (500ms+)",
        "storage-server: Disk Space Low (15%)"
      ]
    }

    render(conn, :index,
      page_title: "Dashboard",
      user: user,
      stats: stats,
      alerts: alerts,
      recent_activities: recent_activities,
      next_postcard: next_postcard
    )
  end
end
