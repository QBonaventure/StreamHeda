defmodule StreamHedaWeb.UsersController do
  use StreamHedaWeb, :controller
  alias StreamHeda.{Steam,Twitch,Repo,User}
  alias Phoenix.LiveView

  def user_page(conn, params) do
    case bc = Repo.get(params) do
      nil ->
        Twitch.get_user(params)
          |> Repo.create
      bc ->
        "nothing"
    end

    LiveView.Controller.live_render(
      conn,
      StreamHedaWeb.UsersLiveView,
      session: %{
        broadcaster: bc,
        user: get_session(conn, "current_user"),
        led_color: %{r: 255, g: 0, b: 0}
      }
    )
  end

  def manager(conn, _) do
    games_list = Steam.get_games_list(get_session(conn, :current_user))
    changeset = User.add_steam_id_changeset(get_session(conn, :current_user))

    conn
    |> render("manager.html", steam_games: games_list, changeset: changeset)
  end


  def add_steam_id(conn, %{"user" => %{"steam_id" => steam_id}}) do
    changeset = get_session(conn, "current_user")
    |> User.add_steam_id_changeset(%{steam_id: steam_id})

    case Repo.update(changeset) do
      {:ok, user} ->
        conn
        |> fetch_session
        |> delete_session(:current_user)
        |> put_session(:current_user, user)
      {:error, _} ->
        "TO BE IMPLEMENTED"
    end

    redirect(conn, to: Routes.users_path(conn, :manager))
  end

end
