defmodule StreamHeda.Repo do
  use Ecto.Repo,
    otp_app: :stream_heda,
    adapter: Ecto.Adapters.Postgres
  alias StreamHeda.User


  def get(%{"user_login" => login}) do

    StreamHeda.Repo.get_by(User, login: login)
  end

  def get(%{id: id}) do
    Repo.get!(User, id)
  end

  def create(%{display_name: name, id: id, login: login}) do
    changeset = User.registration_changeset(%User{}, %{display_name: name, id: id, login: login})
    StreamHeda.Repo.insert(changeset)
  end

  def get_users() do
    User
    |> StreamHeda.Repo.all
  end

end
