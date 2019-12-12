defmodule StreamHedaWeb.ManagerView do
  use Phoenix.LiveView
  alias StreamHedaWeb.LayoutView
  alias StreamHeda.User


  def render(assigns) do
    ~L"""
    <section id="broadcaster-steam-games-list">
      <h1>My Steam Games</h1>

      <%= user = LayoutView.current_user(@conn)
      case user.steam_id do
        nil ->
          LayoutView.render(StreamHedaWeb.AuthView, "steam_login.html", user: user, changeset: @changeset, conn: @conn)
        _ ->
          LayoutView.render("manager_steam_games_list.html", steam_games: @steam_games)
        end %>
    </section>
    """
  end

  def mount(_session, socket) do
    {:ok, assign(socket, deploy_step: "Ready!")}
  end


end
