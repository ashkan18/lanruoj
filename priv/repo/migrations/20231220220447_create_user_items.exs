defmodule Lanruoj.Repo.Migrations.CreateUserItems do
  use Ecto.Migration

  def change do
    create table(:user_items) do
      add :item, :string
      add :type, :string
      add :user_id, references(:users, on_delete: :nothing)

      timestamps(type: :utc_datetime)
    end

    create index(:user_items, [:user_id])
  end
end
