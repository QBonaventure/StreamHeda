defmodule StreamHedaWeb.AuthController do
  use StreamHedaWeb, :controller


  alias StreamHeda.Twitch

  def index(conn, _) do
    redirect(conn, external: Twitch.authorize_url!)
  end

  def callback(conn, %{"code" => code}) do
    client = Twitch.get_token!([code: code, client_secret: Application.get_env(:stream_heda, StreamHeda.Twitch)[:client_secret]])
    user = Twitch.get_user(client.token)

    conn
    |> put_session(:current_user, user)
    |> put_session(:access_token, client.token.access_token)
    |> put_flash(:info, "Hello #{user.username}! You are logged in!")
    |> redirect(to: "/")
  end

  def logout(conn, _) do
    conn
    |> clear_session
    |> redirect to: "/"
  end

end
