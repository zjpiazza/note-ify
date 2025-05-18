defmodule NoteIfyWeb.AuthController do
  use NoteIfyWeb, :controller
  require Logger

  # GET routes to render the forms
  def login(conn, _params) do
    render(conn, :login, page_title: "Login")
  end

  def signup(conn, _params) do
    render(conn, :signup, page_title: "Sign Up")
  end

  def logout(conn, _params) do
    conn
    |> clear_session()
    |> put_flash(:info, "Logged out successfully")
    |> redirect(to: "/")
  end
end
