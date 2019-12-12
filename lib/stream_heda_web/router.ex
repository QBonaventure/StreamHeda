defmodule StreamHedaWeb.Router do
  use StreamHedaWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug Phoenix.LiveView.Flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", StreamHedaWeb do
    pipe_through :browser

    get "/", PageController, :index

    live "/manager_live", UserManagerLive, session: [:current_user]
    get "/manager", UsersController, :manager
    put "/manager/addSteamId", UsersController, :add_steam_id

    get "/broadcasters", UsersController, :index
    get "/broadcasters/:user_login", UsersController, :user_page

    get "/auth", AuthController, :index
    get "/auth/callback", AuthController, :callback
    get "/auth/logout", AuthController, :logout
  end

  # Other scopes may use custom stacks.
  # scope "/api", StreamHedaWeb do
  #   pipe_through :api
  # end
end
