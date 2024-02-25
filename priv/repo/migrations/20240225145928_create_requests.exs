defmodule ExLimiter.Repo.Migrations.CreateRequests do
  use Ecto.Migration

  def change do
    create table(:requests) do
      add :url, :string

      timestamps(type: :utc_datetime)
    end
  end
end
