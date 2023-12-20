defmodule Lanruoj.AnalysisTest do
  use Lanruoj.DataCase

  alias Lanruoj.Analysis

  describe "user_items" do
    alias Lanruoj.Analysis.UserItems

    import Lanruoj.AnalysisFixtures

    @invalid_attrs %{type: nil, item: nil}

    test "list_user_items/0 returns all user_items" do
      user_items = user_items_fixture()
      assert Analysis.list_user_items() == [user_items]
    end

    test "get_user_items!/1 returns the user_items with given id" do
      user_items = user_items_fixture()
      assert Analysis.get_user_items!(user_items.id) == user_items
    end

    test "create_user_items/1 with valid data creates a user_items" do
      valid_attrs = %{type: "some type", item: "some item"}

      assert {:ok, %UserItems{} = user_items} = Analysis.create_user_items(valid_attrs)
      assert user_items.type == "some type"
      assert user_items.item == "some item"
    end

    test "create_user_items/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Analysis.create_user_items(@invalid_attrs)
    end

    test "update_user_items/2 with valid data updates the user_items" do
      user_items = user_items_fixture()
      update_attrs = %{type: "some updated type", item: "some updated item"}

      assert {:ok, %UserItems{} = user_items} = Analysis.update_user_items(user_items, update_attrs)
      assert user_items.type == "some updated type"
      assert user_items.item == "some updated item"
    end

    test "update_user_items/2 with invalid data returns error changeset" do
      user_items = user_items_fixture()
      assert {:error, %Ecto.Changeset{}} = Analysis.update_user_items(user_items, @invalid_attrs)
      assert user_items == Analysis.get_user_items!(user_items.id)
    end

    test "delete_user_items/1 deletes the user_items" do
      user_items = user_items_fixture()
      assert {:ok, %UserItems{}} = Analysis.delete_user_items(user_items)
      assert_raise Ecto.NoResultsError, fn -> Analysis.get_user_items!(user_items.id) end
    end

    test "change_user_items/1 returns a user_items changeset" do
      user_items = user_items_fixture()
      assert %Ecto.Changeset{} = Analysis.change_user_items(user_items)
    end
  end
end
