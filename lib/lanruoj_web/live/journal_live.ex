defmodule LanruojWeb.JournalLive do
  alias Lanruoj.Journals.JournalItem
  alias Lanruoj.Journals
  use LanruojWeb, :live_view

  alias Lanruoj.Accounts

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
            field={@journal_form[:journal_description]}
            type="text"
            label="Description"
            required
          />
          <:actions>
            <.button phx-disable-with="Changing...">Add Item</.button>
          </:actions>
        </.simple_form>
      </div>
    </div>
    """
  end

  def mount(_params, _session, socket) do
    user = socket.assigns.current_user
    journal_changeset = Journals.add_journal_changeset(%JournalItem{}, %{user_id: user.id})
    today_journals = Journals.get_user_journals_by_date(user.id, DateTime.utc_now())
    socket =
      socket
      |> assign(:current_email, user.email)
      |> assign(:today_journals, today_journals)
      |> assign(:journal_form, to_form(journal_changeset))

    {:ok, socket}
  end

  def handle_event("check_text", params, socket) do
    %{"description" => description} = params
    user = socket.assigns.current_user

    {:noreply, socket}
  end
end
