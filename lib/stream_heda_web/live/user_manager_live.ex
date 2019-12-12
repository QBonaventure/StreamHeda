defmodule StreamHedaWeb.UserManagerLive do
  use Phoenix.LiveView
  alias StreamHeda.{Steam,User,Repo}


  def render(assigns) do
    StreamHedaWeb.ManagerLiveView.render("manager.html", assigns)
  end


  def mount(session, socket) do
    games_list = Steam.get_games_list(session.current_user)
    changeset = User.add_steam_id_changeset(session.current_user)

    socket =
      socket
      |> assign(user: session.current_user)
      |> assign(steam_games: games_list)
      |> assign(changeset: changeset)


    {:ok, socket}
  end

  def handle_event("submit-steam-id", value, socket) do
    changeset = User.add_steam_id_changeset(
      socket.assigns.user,
      %{steam_id: value["user"]["steam_id"]}
    )

    case Repo.update(changeset) do
      {:ok, user} ->
        games_list = Steam.get_games_list(user)
        {:noreply, assign(socket, steam_games: games_list)}
      {:error, changeset} ->
        {:noreply, assign(socket, changeset: changeset)}
    end
  end

end
