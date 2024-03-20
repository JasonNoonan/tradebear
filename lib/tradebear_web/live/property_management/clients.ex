defmodule TradebearWeb.PropertyManagement.ClientsLive do
  use TradebearWeb, :live_view
  alias Tradebear.PropertyManagement.Client

  def render(assigns) do
    ~H"""
    <h2>Clients</h2>
    <div>
      <div :for={client <- @clients} class="flex column gap-5">
        <div class="flex row gap-5">
          <%= client.name %>
          <.button type="button" phx-click="add_contact" phx-value-client-id={client.id}>
            Add Contact
          </.button>
          <.button type="button" phx-click="manage_client" phx-value-client-id={client.id}>
            Manage
          </.button>
        </div>
      </div>
    </div>
    """
  end

  def mount(_params, _session, socket) do
    clients = Client.get_all!()

    {:ok, assign(socket, clients: clients)}
  end

  def handle_event("add_contact", %{"client-id" => client_id}, socket) do
    {:noreply, redirect(socket, to: ~p"/clients/#{client_id}/add_contact")}
  end

  def handle_event("manage_client", %{"client-id" => client_id}, socket) do
    {:noreply, redirect(socket, to: ~p"/clients/#{client_id}")}
  end
end
