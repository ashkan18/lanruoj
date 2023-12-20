defmodule Lanruoj.Analysis.UserItems do
  use Ecto.Schema
  import Ecto.Changeset

  schema "user_items" do
    field :type, :string
    field :item, :string
    field :user_id, :id

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(user_items, attrs) do
    user_items
    |> cast(attrs, [:item, :type])
    |> validate_required([:item, :type])
  end
end
