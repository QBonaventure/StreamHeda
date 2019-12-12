defmodule StreamHeda.Repo.Migrations.AddBroadcasterTable do
  use Ecto.Migration

  def up do
    create table(:users, primary_key: false) do
      add :id, :id, primary_key: true
      add :login, :string
      add :display_name, :string

      timestamps()
    end
  end

  def down do
    drop table(:users)
  end
end
