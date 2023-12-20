defmodule Lanruoj.Analysis do
  @moduledoc """
  The Analysis context.
  """



  import Ecto.Query, warn: false
  alias Lanruoj.Journals.JournalItem
  alias Lanruoj.Repo

  alias Lanruoj.Analysis.UserItems

  @people_regex ~r/[.]*(@[\w]*)\s*[.]*/

  @doc """
  Returns the list of user_items.

  ## Examples

      iex> list_user_items()
      [%UserItems{}, ...]

  """
  def list_user_items do
    Repo.all(UserItems)
  end

  @doc """
  Gets a single user_items.

  Raises `Ecto.NoResultsError` if the User items does not exist.

  ## Examples

      iex> get_user_items!(123)
      %UserItems{}

      iex> get_user_items!(456)
      ** (Ecto.NoResultsError)

  """
  def get_user_items!(id), do: Repo.get!(UserItems, id)

  @doc """
  Creates a user_items.

  ## Examples

      iex> create_user_items(%{field: value})
      {:ok, %UserItems{}}

      iex> create_user_items(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_user_items(attrs \\ %{}) do
    %UserItems{}
    |> UserItems.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a user_items.

  ## Examples

      iex> update_user_items(user_items, %{field: new_value})
      {:ok, %UserItems{}}

      iex> update_user_items(user_items, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_user_items(%UserItems{} = user_items, attrs) do
    user_items
    |> UserItems.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a user_items.

  ## Examples

      iex> delete_user_items(user_items)
      {:ok, %UserItems{}}

      iex> delete_user_items(user_items)
      {:error, %Ecto.Changeset{}}

  """
  def delete_user_items(%UserItems{} = user_items) do
    Repo.delete(user_items)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking user_items changes.

  ## Examples

      iex> change_user_items(user_items)
      %Ecto.Changeset{data: %UserItems{}}

  """
  def change_user_items(%UserItems{} = user_items, attrs \\ %{}) do
    UserItems.changeset(user_items, attrs)
  end

  def analyze_journal(%JournalItem{} = journal_item) do
     @people_regex
      |> Regex.scan(journal_item.description)
      |> Enum.map(fn [match|_] -> match end)
  end
end
