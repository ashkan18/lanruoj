defmodule Lanruoj.Journals.JournalItem do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "journal_items" do
    field :journal_description, :string
    field :tags, {:array, :string}
    belongs_to :user, Lanruoj.Accounts.User

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(journal_item, attrs) do
    journal_item
    |> cast(attrs, [:journal_description, :tags])
    |> cast_assoc(:user)
    |> foreign_key_constraint(:user_id)
    |> validate_required([:journal_description, :user_id])
  end
end
