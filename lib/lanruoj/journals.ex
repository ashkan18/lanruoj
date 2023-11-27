defmodule Lanruoj.Journals do
  @moduledoc """
  The Journals context.
  """

  import Ecto.Query, warn: false
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
end
