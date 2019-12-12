defmodule StreamHeda.Repo.Migrations.AddUserEmailAndPpUrlCols do
  use Ecto.Migration

  def change do
    alter table("users") do add :email, :string end
    alter table("users") do add :profile_picture_url, :string end
  end
end
