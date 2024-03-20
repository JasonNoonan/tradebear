defmodule Tradebear.PropertyManagement.Contact do
  use Ash.Resource,
    data_layer: AshPostgres.DataLayer

  postgres do
    table "contacts"
    repo Tradebear.Repo
  end

  code_interface do
    define_for Tradebear.PropertyManagement

    define :create, action: :create
    define :link_to_client, args: [:destination_client_id, :primary?]
    define :get_by_id, args: [:id]
  end

  actions do
    defaults [:create, :read, :update, :destroy]

    read :get_by_id do
      get? true
      argument :id, :uuid, allow_nil?: false

      filter expr(id == ^arg(:id))
    end

    update :link_to_client do
      accept []

      argument :destination_client_id, :uuid, allow_nil?: false
      argument :primary?, :boolean, allow_nil?: true, default: false

      manual fn changeset, _ ->
        with {:ok, client_id} <-
               Ash.Changeset.fetch_argument(changeset, :destination_client_id),
             {:ok, primary?} <- Ash.Changeset.fetch_argument(changeset, :primary?),
             {:ok, _} <-
               Tradebear.PropertyManagement.ClientContact.create(
                 changeset.data.id,
                 client_id,
                 %{primary_contact: primary?}
               ) do
          {:ok, changeset.data}
        end
      end
    end
  end

  attributes do
    uuid_primary_key :id

    attribute :name, :string, allow_nil?: false
    attribute :email, :string, allow_nil?: false
    attribute :phone, :string, allow_nil?: false
    attribute :address, :string, allow_nil?: false
  end

  relationships do
    has_many :notes, Tradebear.PropertyManagement.Note do
      filter expr(not is_nil(contact_id))
      destination_attribute :contact_id
    end
  end
end
