defmodule Lanruoj.Repo.Migrations.CreateJournalItems do
  use Ecto.Migration

  def change do
    create table(:journal_items, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :journal_description, :text
      add :tags, {:array, :string}
      add :user_id, references(:users, on_delete: :nothing, type: :binary_id), null: false

      timestamps(type: :utc_datetime)
    end

    create index(:journal_items, [:user_id])
  end
end
