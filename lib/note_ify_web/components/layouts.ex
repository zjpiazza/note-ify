defmodule NoteIfyWeb.Layouts do
  @moduledoc """
  This module holds different layouts used by your application.

  See the `layouts` directory for all templates available.
  The "root" layout is a skeleton rendered as part of the
  application router. The "app" layout is set as the default
  layout on both `use NoteIfyWeb, :controller` and
  `use NoteIfyWeb, :live_view`.
  """
  use NoteIfyWeb, :html

  # Properly embed templates from layouts directory
  embed_templates "layouts/*"

  # Helper to extract current path from various contexts
  defp extract_request_path(assigns) do
    cond do
      has_conn_struct?(assigns) -> assigns.conn.request_path
      has_conn_map?(assigns) -> assigns["conn"].request_path
      has_socket_current_path?(assigns) -> assigns.socket.assigns.current_path
      Map.has_key?(assigns, :current_path) -> assigns.current_path
      has_uri_struct?(assigns) -> to_string(assigns.uri.path)
      true -> "/"
    end
  end

  defp has_conn_struct?(assigns) do
    Map.has_key?(assigns, :conn) and is_struct(assigns.conn, Plug.Conn)
  end

  defp has_conn_map?(assigns) do
    is_map(assigns) and Map.has_key?(assigns, "conn")
  end

  defp has_socket_current_path?(assigns) do
    Map.has_key?(assigns, :socket) and is_struct(assigns.socket, Phoenix.LiveView.Socket) and Map.has_key?(assigns.socket.assigns, :current_path)
  end

  defp has_uri_struct?(assigns) do
    Map.has_key?(assigns, :uri) and is_struct(assigns.uri, URI)
  end

  # This is called by Phoenix for the :app layout
  def app(assigns) do
    current_path = extract_request_path(assigns)
    assigns_with_path = Map.put(assigns, :request_path, current_path)
    app_html(assigns_with_path)
  end

  # This is called by Phoenix for the :root layout
  def root(assigns) do
    root_html(assigns)
  end

  # Define app_html/1 manually using ~H with the original template content
  def app_html(assigns) do
    ~H"""
    <div class="drawer lg:drawer-open">
      <input id="sidebar-drawer" type="checkbox" class="drawer-toggle" />
      <div class="drawer-content flex flex-col">
        <!-- Navbar -->
        <div class="navbar bg-base-100 shadow-sm">
          <div class="flex-none lg:hidden">
            <label for="sidebar-drawer" class="btn btn-square btn-ghost">
              <svg
                xmlns="http://www.w3.org/2000/svg"
                fill="none"
                viewBox="0 0 24 24"
                class="inline-block w-6 h-6 stroke-current"
              >
                <path
                  stroke-linecap="round"
                  stroke-linejoin="round"
                  stroke-width="2"
                  d="M4 6h16M4 12h16M4 18h16"
                >
                </path>
              </svg>
            </label>
          </div>
          <div class="flex-1">
            <a href="/" class="btn btn-ghost normal-case text-xl">NoteIfy</a>
          </div>
          <div class="flex-none">
            <div class="dropdown dropdown-end">
              <label tabindex="0" class="btn btn-ghost btn-circle avatar">
                <div class="w-10 rounded-full">
                  <img src="https://daisyui.com/images/stock/photo-1534528741775-53994a69daeb.jpg" />
                </div>
              </label>
              <ul
                tabindex="0"
                class="mt-3 z-[1] p-2 shadow menu menu-sm dropdown-content bg-base-100 rounded-box w-52"
              >
                <li><a href="/settings">Settings</a></li>
                <li><a>Logout</a></li>
              </ul>
            </div>
          </div>
        </div>
        
    <!-- Main content -->
        <main class="flex-1 p-6 lg:px-8">
          <.flash_group flash={@flash} />
          {@inner_content}
        </main>
      </div>
      
    <!-- Sidebar -->
      <div class="drawer-side">
        <label for="sidebar-drawer" class="drawer-overlay"></label>
        <aside class="bg-base-200 w-64 h-full">
          <div class="p-4">
            <a href="/" class="text-2xl font-bold">NoteIfy</a>
          </div>
          <ul class="menu p-4 w-full text-base-content">
            <li>
              <a
                href="/dashboard"
                class={~c"font-medium #{if @request_path == "/dashboard", do: "active", else: ""}"}
              >
                <svg
                  xmlns="http://www.w3.org/2000/svg"
                  class="h-5 w-5"
                  fill="none"
                  viewBox="0 0 24 24"
                  stroke="currentColor"
                >
                  <path
                    stroke-linecap="round"
                    stroke-linejoin="round"
                    stroke-width="2"
                    d="M3 12l2-2m0 0l7-7 7 7M5 10v10a1 1 0 001 1h3m10-11l2 2m-2-2v10a1 1 0 01-1 1h-3m-6 0a1 1 0 001-1v-4a1 1 0 011-1h2a1 1 0 011 1v4a1 1 0 001 1m-6 0h6"
                  >
                  </path>
                </svg>
                Dashboard
              </a>
            </li>
            <li>
              <a
                href="/billing"
                class={~c"font-medium #{if @request_path == "/billing", do: "active", else: ""}"}
              >
                <svg
                  xmlns="http://www.w3.org/2000/svg"
                  class="h-5 w-5"
                  fill="none"
                  viewBox="0 0 24 24"
                  stroke="currentColor"
                >
                  <path
                    stroke-linecap="round"
                    stroke-linejoin="round"
                    stroke-width="2"
                    d="M3 10h18M7 15h1m4 0h1m-7 4h12a3 3 0 003-3V8a3 3 0 00-3-3H6a3 3 0 00-3 3v8a3 3 0 003 3z"
                  >
                  </path>
                </svg>
                Billing
              </a>
            </li>
            <li>
              <a
                href="/settings"
                class={~c"font-medium #{if @request_path == "/settings", do: "active", else: ""}"}
              >
                <svg
                  xmlns="http://www.w3.org/2000/svg"
                  class="h-5 w-5"
                  fill="none"
                  viewBox="0 0 24 24"
                  stroke="currentColor"
                >
                  <path
                    stroke-linecap="round"
                    stroke-linejoin="round"
                    stroke-width="2"
                    d="M10.325 4.317c.426-1.756 2.924-1.756 3.35 0a1.724 1.724 0 002.573 1.066c1.543-.94 3.31.826 2.37 2.37a1.724 1.724 0 001.065 2.572c1.756.426 1.756 2.924 0 3.35a1.724 1.724 0 00-1.066 2.573c.94 1.543-.826 3.31-2.37 2.37a1.724 1.724 0 00-2.572 1.065c-.426 1.756-2.924 1.756-3.35 0a1.724 1.724 0 00-2.573-1.066c-1.543.94-3.31-.826-2.37-2.37a1.724 1.724 0 00-1.065-2.572c-1.756-.426-1.756-2.924 0-3.35a1.724 1.724 0 001.066-2.573c-.94-1.543.826-3.31 2.37-2.37.996.608 2.296.07 2.572-1.065z"
                  >
                  </path>
                  <path
                    stroke-linecap="round"
                    stroke-linejoin="round"
                    stroke-width="2"
                    d="M15 12a3 3 0 11-6 0 3 3 0 016 0z"
                  >
                  </path>
                </svg>
                Settings
              </a>
            </li>
          </ul>
        </aside>
      </div>
    </div>
    """
  end

  # HTML for the :root layout
  def root_html(assigns) do
    ~H"""
    <!DOCTYPE html>
    <html lang="en">
      <head>
        <meta charset="utf-8" />
        <meta http-equiv="X-UA-Compatible" content="IE=edge" />
        <meta name="viewport" content="width=device-width, initial-scale=1.0" />
        <title>NoteIfy</title>
        <link phx-track-static rel="stylesheet" href={~p"/assets/app.css"} />
        <script defer phx-track-static type="text/javascript" src={~p"/assets/app.js"}>
        </script>
      </head>
      <body>
        {@inner_content}
      </body>
    </html>
    """
  end
end
