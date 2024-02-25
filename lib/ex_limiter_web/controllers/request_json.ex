defmodule ExLimiterWeb.RequestJSON do
  alias ExLimiter.Limiter.Request

  @doc """
  Renders a list of requests.
  """
  def index(%{requests: requests}) do
    %{data: for(request <- requests, do: data(request))}
  end

  @doc """
  Renders a single request.
  """
  def show(%{request: request}) do
    %{data: data(request)}
  end

  defp data(%Request{} = request) do
    %{
      id: request.id,
      url: request.url
    }
  end
end
