defmodule StreamHedaWeb.PageController do
  use StreamHedaWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
