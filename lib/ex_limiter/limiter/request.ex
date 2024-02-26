defmodule ExLimiter.Limiter.Request do
  use Ecto.Schema
  import Ecto.Changeset

  schema "requests" do
    field :url, :string
    belongs_to :user, ExLimiter.Accounts.User

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(request, attrs) do
    request
    |> cast(attrs, [:url, :user_id])
    |> validate_required([:url, :user_id])
    |> foreign_key_constraint(:user_id)
  end
end
