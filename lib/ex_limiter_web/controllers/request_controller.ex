defmodule ExLimiterWeb.RequestController do
  use ExLimiterWeb, :controller

  alias ExLimiter.Limiter
  alias ExLimiter.Limiter.Request

  action_fallback ExLimiterWeb.FallbackController

  def index(conn, _params) do
    requests = Limiter.list_requests()
    render(conn, :index, requests: requests)
  end

  def create(conn, %{"request" => request_params}) do
    with {:ok, %Request{} = request} <- Limiter.create_request(request_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", ~p"/api/requests/#{request}")
      |> render(:show, request: request)
    end
  end

  def show(conn, %{"id" => id}) do
    request = Limiter.get_request!(id)
    render(conn, :show, request: request)
  end

  def update(conn, %{"id" => id, "request" => request_params}) do
    request = Limiter.get_request!(id)

    with {:ok, %Request{} = request} <- Limiter.update_request(request, request_params) do
      render(conn, :show, request: request)
    end
  end

  def delete(conn, %{"id" => id}) do
    request = Limiter.get_request!(id)

    with {:ok, %Request{}} <- Limiter.delete_request(request) do
      send_resp(conn, :no_content, "")
    end
  end
end
