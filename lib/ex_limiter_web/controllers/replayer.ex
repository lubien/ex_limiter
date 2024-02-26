defmodule ExLimiterWeb.Replayer do
  import Plug.Conn

  alias ExLimiter.Limiter

  def init(_) do
    []
  end

  def call(conn, _params) do
    user_id = 1

    case get_req_header(conn, "host") do
      ["scrapper:4000"] ->
        limits = Limiter.calculate_limit_for_user(user_id)

        conn =
          conn
          |> put_resp_header("x-ratelimit-used", to_string(limits.used))
          |> put_resp_header("x-ratelimit-remaining", to_string(limits.remaining))
          |> put_resp_header("x-ratelimit-limit", to_string(limits.limit))
          |> put_resp_header("x-ratelimit-reset", limits.reset |> DateTime.to_unix() |> to_string())

        if limits.remaining > 0 do
          Task.Supervisor.async(ExLimiter.RequestSaveSupervisor, fn ->
            {:ok, _req} = Limiter.create_request(%{user_id: user_id, url: conn.request_path})
          end)

          conn
          |> handle_replay()
        else
          conn
          |> send_resp(429, "Too many requests")
        end

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
