defmodule StreamHeda.User do
  use Ecto.Schema
  import Ecto.{Query,Changeset}
  alias StreamHeda.User

  schema "users" do

    field :login, :string
    field :display_name, :string
    field :email, :string
    field :profile_picture_url, :string
    field :steam_id, :integer
    has_many :links, StreamHeda.User.Link

    timestamps()
  end

  def is_broadcaster(%User{id: broadcaster_id}, %User{id: user_id}) do
    broadcaster_id == user_id
  end


  def registration_changeset(user, params \\ %{}) do
    user
    |> cast(params, [:id, :login, :display_name, :email, :profile_picture_url])
    |> validate_required([:id, :login, :display_name, :email])
    |> unique_constraint(:id)
    |> unique_constraint(:login)
    |> unique_constraint(:email)
    |> unique_constraint(:display_name)
  end

  @doc false
  def changeset(user, params \\ %{}) do
    user
    |> cast(params, [:login, :email, :steam_id, :profile_picture_url])
    |> validate_required([:login, :email])
    |> unique_constraint(:login)
    |> unique_constraint(:email)
    |> unique_constraint(:display_name)
    |> unique_constraint(:steam_id)
  end

  def get_users_by_country(users, country, limit) do
    Enum.filter(users, fn(x) -> x.country == country end)
    |> Enum.take(limit)
  end

  def add_steam_id_changeset(user, params \\ %{}) do
    user
    |> cast(params, [:steam_id])
    |> validate_number(:steam_id, greater_than_or_equal_to: 76561197960265729)
    |> validate_number(:steam_id, less_than_or_equal_to: 76561202255233023)
    |> validate_required([:steam_id])
    |> unique_constraint(:steam_id)
  end

end
