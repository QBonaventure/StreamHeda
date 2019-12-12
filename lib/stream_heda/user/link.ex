defmodule StreamHeda.User.Link do
  use Ecto.Schema
  import Ecto.{Query,Changeset}
  alias StreamHeda.User.Link

    schema "users_links" do
      field :service_id, :integer
      field :url, :string
      field :profile_picture_url, :string
      belongs_to :user, StreamHeda.User
    end
  end
