defmodule StreamHedaWeb.UsersLiveView do
  use Phoenix.LiveView

  def render(assigns) do
    StreamHedaWeb.UsersView.render("user_page.html", assigns)
  end

  def mount(session, socket) do
    socket =
      socket
      |> assign(user: session.user)
      |> assign(broadcaster: session.broadcaster)
      |> assign(led_color: session.led_color)

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
