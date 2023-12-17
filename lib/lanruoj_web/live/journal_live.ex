defmodule LanruojWeb.JournalLive do
  alias Lanruoj.Journals.Commands
  alias Lanruoj.Journals.JournalItem
  alias Lanruoj.Journals
  alias Phoenix.LiveView.AsyncResult

  use LanruojWeb, :live_view

  def render(assigns) do
    ~H"""
    <.header class="text-center">
      Hello <%= @current_email %>
      <:subtitle>Add Journals As the Day Goes By 🚶</:subtitle>
    </.header>

    <div class="space-y-12 divide-y">
      <div>
        <.simple_form
          for={@journal_form}
          id="journal"
          phx-submit="add_journal"
          phx-change="check_text"
        >
          <.input
            field={@journal_form[:description]}
            type="text"
            label="Description"
            list="commands"
            required
          />
          <datalist id="commands">
            <%= for command <- Map.keys(@commands) do %>
              <option value={ Map.fetch!(@commands, command) }> <%= command %> </option>
            <% end %>
          </datalist>
          <:actions>
            <.button phx-disable-with="Changing...">Add Item</.button>
          </:actions>
        </.simple_form>
        <.async_result :let={today_journals} assign={@today_journals}>
          <:loading>Loading journals...</:loading>
          <:failed :let={_reason}>there was an error loading journals</:failed>
          <%= for journal <- today_journals do %>
            <div><%= journal.description %></div>
          <% end %>
        </.async_result>
      </div>
    </div>
    """
  end

  def mount(_params, _session, socket) do
    user = socket.assigns.current_user
    journal_changeset = Journals.add_journal_changeset(%JournalItem{}, %{user_id: user.id})
    socket =
      socket
      |> assign(:current_email, user.email)
      |> assign(:commands, [])
      |> assign(:journal_form, to_form(journal_changeset))
      |> assign(:today_journals, AsyncResult.loading())
      |> assign(:commands, Commands.commands())
      |> start_async(:fetch_journal_items, fn -> Journals.get_user_journals_by_date(user.id, DateTime.utc_now()) end)

    {:ok, socket}
  end

  def handle_event("check_text", params, socket) do
    %{"journal_item" => %{"description" => description}} = params
    # user = socket.assigns.current_user
    case description do
      "/" ->
        {:noreply, socket}

      _ -> {:noreply, socket}
    end
  end

  def handle_event("add_journal", %{"journal_item" => journal_item} , socket) do
    user = socket.assigns.current_user

    case Journals.add_journal(Map.merge(journal_item, %{"user_id" => user.id})) do
      {:ok, _item } ->
        {:noreply, start_async(socket, :fetch_journal_items, fn -> Journals.get_user_journals_by_date(user.id, DateTime.utc_now()) end)}
      {:error, {}} -> {:noreply, socket}
    end
  end

  def handle_async(:fetch_journal_items, {:ok, fetched_journals}, socket) do
    %{today_journals: today_journals} = socket.assigns
    {:noreply, assign(socket, :today_journals, AsyncResult.ok(today_journals, fetched_journals))}
  end

  def handle_async(:fetch_journal_items, {:exit, reason}, socket) do
    %{today_journals: today_journals} = socket.assigns
    {:noreply, assign(socket, :today_journals, AsyncResult.failed(today_journals, {:exit, reason}))}
  end
end
