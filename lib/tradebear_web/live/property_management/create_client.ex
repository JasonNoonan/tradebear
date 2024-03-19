defmodule TradebearWeb.PropertyManagement.CreateClientLive do
  use TradebearWeb, :live_view
  alias Tradebear.PropertyManagement.Client

  def render(assigns) do
    ~H"""
    <h2>Create Client</h2>
    <.form for={@form} phx-change="validate_client" phx-submit="create_client">
      <.input type="text" field={@form[:name]} label="Client Name" />
      <.input type="text" field={@form[:billing_address]} label="Address" />
      <.button type="submit">Create</.button>
    </.form>
    """
  end

  def mount(_params, _session, socket) do
    socket =
      socket
      |> assign(
        form:
          AshPhoenix.Form.for_create(Client, :create, api: Tradebear.PropertyManagement)
          |> to_form()
      )

    {:ok, socket}
  end

  def handle_event("validate_client", %{"form" => form_params}, socket) do
    form = AshPhoenix.Form.validate(socket.assigns.form, form_params)
    {:noreply, assign(socket, form: form)}
  end

  def handle_event("create_client", %{"form" => form_params}, socket) do
    case AshPhoenix.Form.submit(socket.assigns.form, params: form_params) do
      {:ok, _client} ->
        {:noreply, redirect(socket, to: ~p"/clients")}

      {:error, form} ->
        {:noreply, assign(socket, form: form)}
    end
  end
end
