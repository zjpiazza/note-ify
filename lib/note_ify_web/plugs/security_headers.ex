defmodule NoteIfyWeb.Plugs.SecurityHeaders do
  @moduledoc """
  Plug for adding security headers to all responses
  """
  import Plug.Conn

  def init(opts), do: opts

  def call(conn, _opts) do
    conn
    |> put_resp_header("x-frame-options", "SAMEORIGIN")
    |> put_resp_header("x-content-type-options", "nosniff")
    |> put_resp_header("x-xss-protection", "1; mode=block")
    |> put_resp_header("content-security-policy", csp_header())
    |> put_resp_header("referrer-policy", "strict-origin-when-cross-origin")
  end

  # Content Security Policy header
  defp csp_header do
    """
    default-src 'self';
    connect-src 'self' https://clerk.com https://*.clerk.accounts.dev https://clerk.accounts.dev https://api.clerk.dev https://*.clerk.io;
    script-src 'self' 'unsafe-inline' 'unsafe-eval' blob: https://cdn.clerk.dev https://*.clerk.io https://*.clerk.accounts.dev https://clerk.accounts.dev https://challenges.cloudflare.com;
    style-src 'self' 'unsafe-inline';
    img-src 'self' data: https://img.clerk.com https://*.clerk.accounts.dev https://clerk.accounts.dev https://*.clerk.io;
    font-src 'self' data:;
    frame-src 'self' https://accounts.clerk.accounts.dev https://*.clerk.accounts.dev https://clerk.accounts.dev https://challenges.cloudflare.com;
    worker-src 'self' blob:;
    """
    |> String.replace("\n", " ")
    |> String.trim()
  end
end
