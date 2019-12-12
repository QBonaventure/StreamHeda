defmodule StreamHeda.Repo.Migrations.AddUsersLinksTable do
  use Ecto.Migration

  def change do
    create table(:external_services) do
      add :name, :string
      add :url, :string
    end

    create table(:users_links) do
      add :user_id, references(:users)
      add :service_id, references(:external_services)
      add :url, :string
      add :display_name, :string
      timestamps
    end
    create unique_index(:users_links, [:user_id])

    flush

    add_external_services_data
  end

  def add_external_services_data do
    StreamHeda.Repo.insert_all(
      StreamHeda.ExternalService,
      [
        %{name: "Discord", url: "https://discordapp.com"},
        %{name: "Steam", url: "https://store.steampowered.com"},
        %{name: "Twitter", url: "https://twitter.co"},
        %{name: "Instagram", url: "https://www.instagram.com"},
        %{name: "Facebook", url: "www.facebook.com"}
      ]
    )
  end
end
