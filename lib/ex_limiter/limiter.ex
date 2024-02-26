defmodule ExLimiter.Limiter do
  @moduledoc """
  The Limiter context.
  """

  import Ecto.Query, warn: false
  alias ExLimiter.Repo

  alias ExLimiter.Limiter.Request

  @doc """
  Returns the list of requests.

  ## Examples

      iex> list_requests()
      [%Request{}, ...]

  """
  def list_requests do
    Repo.all(Request)
  end

  @doc """
  Gets a single request.

  Raises `Ecto.NoResultsError` if the Request does not exist.

  ## Examples

      iex> get_request!(123)
      %Request{}

      iex> get_request!(456)
      ** (Ecto.NoResultsError)

  """
  def get_request!(id), do: Repo.get!(Request, id)

  @doc """
  Creates a request.

  ## Examples

      iex> create_request(%{field: value})
      {:ok, %Request{}}

      iex> create_request(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_request(attrs \\ %{}) do
    %Request{}
    |> Request.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a request.

  ## Examples

      iex> update_request(request, %{field: new_value})
      {:ok, %Request{}}

      iex> update_request(request, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_request(%Request{} = request, attrs) do
    request
    |> Request.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a request.

  ## Examples

      iex> delete_request(request)
      {:ok, %Request{}}

      iex> delete_request(request)
      {:error, %Ecto.Changeset{}}

  """
  def delete_request(%Request{} = request) do
    Repo.delete(request)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking request changes.

  ## Examples

      iex> change_request(request)
      %Ecto.Changeset{data: %Request{}}

  """
  def change_request(%Request{} = request, attrs \\ %{}) do
    Request.changeset(request, attrs)
  end

  def calculate_limit_for_user(user_id) do
    minute_string = (
      DateTime.utc_now(:second)
      |> DateTime.to_iso8601()
      |> String.slice(0, 16)
    )

    {:ok, bucket_start, 0} = DateTime.from_iso8601("#{minute_string}:00Z")
    bucket_end = DateTime.add(bucket_start, 60, :second)

    requests_in_bucket =
      Request
      |> where(user_id: ^user_id)
      |> where([r], r.inserted_at >= ^bucket_start and r.inserted_at <= ^bucket_end)
      |> Repo.aggregate(:count)

    limit = 60
    %{
      used: requests_in_bucket,
      remaining: limit - requests_in_bucket,
      limit: limit,
      reset: bucket_end
    }
  end
end
