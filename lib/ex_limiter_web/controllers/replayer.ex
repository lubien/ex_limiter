defmodule ExLimiterWeb.Replayer do
  import Plug.Conn

  def init(_) do
    []
  end

  def call(conn, _params) do
    case get_req_header(conn, "host") do
      ["scrapper:4000"] ->
        handle_replay(conn)

      _ ->
        conn
    end
  end

  def handle_replay(conn) do
    proxy_params = [upstream: "//localhost:3000", response_mode: :buffer]
    opts = ReverseProxyPlug.init(proxy_params)
    ReverseProxyPlug.call(conn, opts)
    |> halt()
  end
end
