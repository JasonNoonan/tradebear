defmodule Tradebear.PropertyManagement.Client do
  use Ash.Resource,
    data_layer: AshPostgres.DataLayer

  postgres do
    table "clients"
    repo Tradebear.Repo
  end

  code_interface do
    define_for Tradebear.PropertyManagement

    define :create, action: :create
    define :get_all, action: :read
    define :get_by_id, args: [:id]
  end

  actions do
    defaults [:create, :read, :update, :destroy]

    read :get_by_id do
      get? true
      argument :id, :uuid, allow_nil?: false

      filter expr(id == ^arg(:id))
    end
  end

  attributes do
    uuid_primary_key :id

    attribute :name, :string, allow_nil?: false
    attribute :billing_address, :string, allow_nil?: false
  end

  relationships do
    has_many :notes, Tradebear.PropertyManagement.Note

    many_to_many :contacts, Tradebear.PropertyManagement.Contact do
      through Tradebear.PropertyManagement.ClientContact
      source_attribute :id
      source_attribute_on_join_resource :client_id
      destination_attribute :id
      destination_attribute_on_join_resource :contact_id
    end

    has_one :primary_contact, Tradebear.PropertyManagement.ClientContact do
      filter expr(primary_contact)
      destination_attribute :client_id
    end

    has_many :properties, Tradebear.PropertyManagement.Property
  end
end
