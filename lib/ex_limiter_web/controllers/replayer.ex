defmodule ExLimiterWeb.Replayer do
  import Plug.Conn

  alias ExLimiter.Limiter

  def init(_) do
    []
  end

  def call(conn, _params) do
    case get_req_header(conn, "host") do
      ["scrapper:4000"] ->
        Task.Supervisor.async(ExLimiter.RequestSaveSupervisor, fn ->
          {:ok, _req} = Limiter.create_request(%{user_id: 1, url: conn.request_path})
        end)
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
