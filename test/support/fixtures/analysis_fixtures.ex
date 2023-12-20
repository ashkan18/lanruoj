defmodule Lanruoj.AnalysisFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Lanruoj.Analysis` context.
  """

  @doc """
  Generate a user_items.
  """
  def user_items_fixture(attrs \\ %{}) do
    {:ok, user_items} =
      attrs
      |> Enum.into(%{
        item: "some item",
        type: "some type"
      })
      |> Lanruoj.Analysis.create_user_items()

    user_items
  end
end
