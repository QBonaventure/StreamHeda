defmodule StreamHedaWeb.Router do
  use StreamHedaWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", StreamHedaWeb do
    pipe_through :browser

    get "/", PageController, :index

    get "/auth", AuthController, :index
    get "/auth/callback", AuthController, :callback
    get "/auth/logout", AuthController, :logout
  end

  # Other scopes may use custom stacks.
  # scope "/api", StreamHedaWeb do
  #   pipe_through :api
  # end
end
