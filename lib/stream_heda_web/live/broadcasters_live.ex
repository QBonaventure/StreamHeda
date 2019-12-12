defmodule StreamHedaWeb.BroadcastersLive do
  use Phoenix.LiveView
  alias StreamHeda.{User, Repo}


  def render(assigns) do
    StreamHedaWeb.BroadcastersLive.render("broadcaster-page.html")
  end


  def mount(session, socket) do
    # case bc = Repo.get(params) do
    #   nil ->
    #     Twitch.get_user(params)
    #       |> Repo.create
    #   bc ->
    #     "nothing"
    # end
  end


end
