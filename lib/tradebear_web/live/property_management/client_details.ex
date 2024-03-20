defmodule TradebearWeb.PropertyManagement.ClientDetailsLive do
  use TradebearWeb, :live_view
  alias Tradebear.PropertyManagement
  alias Tradebear.PropertyManagement.Client

  def render(assigns) do
    ~H"""
    <h2 class="py-5"><%= @client.name %></h2>
    <p>Billing address: <%= @client.billing_address %></p>

    <h3 class="pt-10">Contacts</h3>
    <div :for={contact <- @contacts} class="flex column gap-5">
      <div class="flex row gap-10">
        <%= contact.name %>
        <%= contact.phone %>
        <%= contact.email %>
        <%= contact.address %>
      </div>
    </div>
    """
  end

  def mount(%{"id" => client_id}, _session, socket) do
    client =
      Client.get_by_id(client_id)
      |> PropertyManagement.load!([:notes, :contacts, :properties])

    {:ok, assign(socket, client: client, contacts: client.contacts)}
  end
end
