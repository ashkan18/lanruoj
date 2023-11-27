defmodule Lanruoj.Journals.JournalItem do
  use Ecto.Schema
  import Ecto.Changeset

  schema "journal_items" do
    field :journal_description, :string
    field :tags, {:array, :string}
    field :user_id, :id

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(journal_item, attrs) do
    journal_item
    |> cast(attrs, [:journal_description, :tags])
    |> validate_required([:journal_description, :tags])
  end
end
