defmodule ExLimiter.Limiter.Request do
  use Ecto.Schema
  import Ecto.Changeset

  schema "requests" do
    field :url, :string

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(request, attrs) do
    request
    |> cast(attrs, [:url])
    |> validate_required([:url])
  end
end
