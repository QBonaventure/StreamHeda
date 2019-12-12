defmodule StreamHeda.Repo.Migrations.AddBroadcasterSteamIdColumn do
  use Ecto.Migration

  def change do
    alter table("users") do add :steam_id, :bigint end
  end

end
