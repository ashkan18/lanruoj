defmodule Lanruoj.Journals do
  @moduledoc """
  The Journals context.
  """

  import Ecto.Query, warn: false
  alias Postgrex.Extensions.Array
  alias Lanruoj.Repo

  alias Lanruoj.Journals.{JournalItem}

  ## Database getters

  ## User registration

  @doc """
  Registers a user.

  ## Examples

      iex> register_user(%{field: value})
      {:ok, %User{}}

      iex> register_user(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def add_journal(attrs) do
    %JournalItem{}
    |> JournalItem.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking journal inserts.

  ## Examples

      iex> add_journal_changeset(user)
      %Ecto.Changeset{data: %User{}}

  """
  def add_journal_changeset(%JournalItem{} = item, attrs \\ %{}) do
    JournalItem.changeset(item, attrs)
  end

  @spec get_user_journals_by_date(String.t(), DateTime.t()) :: list(JournalItem)
  def get_user_journals_by_date(user_id, %DateTime{} = dateTime) do
    from(j in JournalItem,
      where: j.user_id == ^user_id,
      where: fragment("?::date", j.inserted_at) == ^DateTime.to_date(dateTime)
    )
    |> Repo.all()
  end
end
