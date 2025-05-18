defmodule NoteIfyWeb.Plugs.AuthPlug do
  @moduledoc """
  Plug for handling Clerk authentication.
  """
  import Plug.Conn
  require Logger

  # Check if we should use mock authentication in development at compile time
  @use_mock_auth Application.compile_env(:clerk, :api_key) == "YOUR_CLERK_API_KEY"
  @env Mix.env()

  def init(opts), do: opts

  def call(conn, _opts) do
    cond do
      @env == :dev && @use_mock_auth ->
        mock_authentication(conn)

      user = get_session(conn, :clerk_user) ->
        assign_authenticated_user(conn, user)

      true ->
        handle_no_session(conn)
    end
  end

  defp assign_authenticated_user(conn, user) do
    conn
    |> assign(:current_user, user)
    |> assign(:authenticated, true)
  end

  defp handle_no_session(conn) do
    case extract_clerk_session(conn) do
      {:ok, session_token} ->
        verify_clerk_session(conn, session_token)
      :error ->
        conn
        |> assign(:current_user, nil)
        |> assign(:authenticated, false)
    end
  end

  # Extract Clerk session from cookie
  defp extract_clerk_session(conn) do
    case conn.cookies["__session"] do
      nil -> :error
      token -> {:ok, token}
    end
  end

  # Verify the session token with Clerk
  defp verify_clerk_session(conn, token) do
    try do
      case Clerk.Session.verify_and_validate(token) do
        {:ok, claims} ->
          # Extract user data from claims
          user = extract_user_from_claims(claims)

          conn
          |> put_session(:clerk_user, user)
          |> assign(:current_user, user)
          |> assign(:authenticated, true)

        {:error, reason} ->
          Logger.error("Failed to verify Clerk token: #{inspect(reason)}")

          conn
          |> assign(:current_user, nil)
          |> assign(:authenticated, false)
      end
    rescue
      e ->
        Logger.error("Error verifying token: #{inspect(e)}")

        conn
        |> assign(:current_user, nil)
        |> assign(:authenticated, false)
    end
  end

  # Extract user information from JWT claims
  defp extract_user_from_claims(claims) do
    # Map claims to user structure
    %{
      id: claims["sub"],
      email: extract_email_from_claims(claims),
      first_name: claims["first_name"] || claims["given_name"] || "User",
      last_name: claims["last_name"] || claims["family_name"] || "",
      image_url: claims["image"] || claims["picture"],
      username: claims["username"] || claims["sub"]
    }
  end

  # Extract email from claims
  defp extract_email_from_claims(claims) do
    claims["email"] ||
      get_in(claims, ["user_claims", "email"]) ||
      "user@example.com"
  end

  # Simple development authentication
  defp mock_authentication(conn) do
    user = %{
      id: "dev_user",
      email: "dev@example.com",
      first_name: "Dev",
      last_name: "User",
      image_url: nil,
      username: "devuser"
    }

    conn
    |> put_session(:clerk_user, user)
    |> assign(:current_user, user)
    |> assign(:authenticated, true)
  end
end
