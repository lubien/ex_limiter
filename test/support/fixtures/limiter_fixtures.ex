defmodule ExLimiter.LimiterFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `ExLimiter.Limiter` context.
  """

  @doc """
  Generate a request.
  """
  def request_fixture(attrs \\ %{}) do
    {:ok, request} =
      attrs
      |> Enum.into(%{
        url: "some url"
      })
      |> ExLimiter.Limiter.create_request()

    request
  end
end
