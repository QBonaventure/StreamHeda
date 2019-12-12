defmodule StreamHeda.ExternalService do
  use Ecto.Schema
  import Ecto.{Changeset,Query}

    schema "external_services" do
      field :name, :string
      field :url, :string
    end

end
