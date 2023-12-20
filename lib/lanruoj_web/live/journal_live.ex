defmodule LanruojWeb.JournalLive do
  alias Lanruoj.Journals.Commands
  alias Lanruoj.Journals.JournalItem
  alias Lanruoj.Journals
  alias Phoenix.LiveView.AsyncResult

  use LanruojWeb, :live_view

  @default_locale "en"
  @default_timezone "UTC"
  @default_timezone_offset 0

  def render(assigns) do
    ~H"""
    <.header class="text-center">
      Hello <%= @current_email %>
      <:subtitle>Add Journals As the Day Goes By 🚶</:subtitle>
    </.header>

    <div class="space-y-12 divide-y">
      <%= unless connected?(@socket) do %>
        <div style="min-height:90vh">
          <div class="loader">Loading...</div>
        </div>
      <% else %>
        <div>
          <%= @timezone_offset %>
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
                <option value={Map.fetch!(@commands, command)}><%= command %></option>
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
      <% end %>
    </div>
    """
  end

  def mount(_params, _session, socket) do
    user = socket.assigns.current_user
    journal_changeset = Journals.add_journal_changeset(%JournalItem{}, %{user_id: user.id})

    socket =
      socket
      |> assign_locale()
      |> assign_timezone()
      |> assign_timezone_offset()
      |> assign(:current_email, user.email)
      |> assign(:commands, [])
      |> assign(:journal_form, to_form(journal_changeset))
      |> assign(:today_journals, AsyncResult.loading())
      |> assign(:commands, Commands.commands())
      |> assign_async_journals()

    {:ok, socket}
  end

  defp assign_locale(socket) do
    locale = get_connect_params(socket)["locale"] || @default_locale
    assign(socket, locale: locale)
  end

  defp assign_timezone(socket) do
    timezone = get_connect_params(socket)["timezone"] || @default_timezone
    assign(socket, timezone: timezone)
  end

  defp assign_async_journals(socket) do
    user = socket.assigns.current_user
    if connected?(socket) do
      start_async(socket, :fetch_journal_items, fn ->
        Journals.get_user_journals_by_date(user.id, DateTime.utc_now() |> DateTime.add(socket.assigns.timezone_offset * 60 * 60) )
      end)
    else
      socket
    end
  end

  defp assign_timezone_offset(socket) do
    timezone_offset = get_connect_params(socket)["timezone_offset"] || @default_timezone_offset
    assign(socket, timezone_offset: timezone_offset)
  end

  def handle_event("check_text", params, socket) do
    %{"journal_item" => %{"description" => description}} = params
    # user = socket.assigns.current_user
    case description do
      "/" ->
        {:noreply, socket}

      _ ->
        {:noreply, socket}
    end
  end

  def handle_event("add_journal", %{"journal_item" => journal_item}, socket) do
    user = socket.assigns.current_user

    case Journals.add_journal(Map.merge(journal_item, %{"user_id" => user.id})) do
      {:ok, _item} ->
        {:noreply,
         start_async(socket, :fetch_journal_items, fn ->
           Journals.get_user_journals_by_date(user.id, DateTime.utc_now())
         end)}

      {:error, {}} ->
        {:noreply, socket}
    end
  end

  def handle_async(:fetch_journal_items, {:ok, fetched_journals}, socket) do
    %{today_journals: today_journals} = socket.assigns

    {:noreply, assign(socket, :today_journals, AsyncResult.ok(today_journals, fetched_journals))}
  end

  def handle_async(:fetch_journal_items, {:exit, reason}, socket) do
    %{today_journals: today_journals} = socket.assigns
    {:noreply,
     assign(socket, :today_journals, AsyncResult.failed(today_journals, {:exit, reason}))}
  end
end
