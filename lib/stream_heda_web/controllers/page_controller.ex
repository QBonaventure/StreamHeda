defmodule StreamHedaWeb.PageController do
  use StreamHedaWeb, :controller
  alias StreamHeda.Repo

  def index(conn, _params) do
    users = Repo.get_users()
    render(conn, "index.html", users: users)
  end
end
