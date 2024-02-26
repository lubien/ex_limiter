defmodule ExLimiter.Repo.Migrations.AddUserIdToRequest do
  use Ecto.Migration

  def change do
    alter table(:requests) do
      add :user_id, references(:users, on_delete: :delete_all), null: true
    end
  end
end
