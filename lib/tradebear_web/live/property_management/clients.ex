defmodule TradebearWeb.PropertyManagement.ClientsLive do
  use TradebearWeb, :live_view
  alias Tradebear.PropertyManagement.Client

  def render(assigns) do
    ~H"""
    <h2>Clients</h2>
    <div>
      <div :for={client <- @clients} class="flex column gap-5">
        <div><%= client.name %></div>
      </div>
    </div>
    """
  end

  def mount(_params, _session, socket) do
    clients = Client.get_all!()

    {:ok, assign(socket, clients: clients)}
  end
end
