defmodule StreamHeda.Twitch do
  use OAuth2.Strategy
  alias StreamHeda.User

  # Public API

  def client do
    OAuth2.Client.new([
      strategy: __MODULE__,
      client_id: Application.get_env(:stream_heda, StreamHeda.Twitch)[:client_id],
      client_secret: Application.get_env(:stream_heda, StreamHeda.Twitch)[:client_secret],
      redirect_uri: Application.get_env(:stream_heda, StreamHeda.Twitch)[:redirect_uri],
      site: "https://id.twitch.tv/",
      response_type: "code",
      authorize_url: Application.get_env(:stream_heda, StreamHeda.Twitch)[:authorize_url],
      token_url: "https://id.twitch.tv/oauth2/token"
    ])
    |> OAuth2.Client.put_serializer("application/json", Jason)
  end

  def authorize_url! do
    OAuth2.Client.authorize_url!(client(), scope: "analytics:read:games bits:read channel:read:subscriptions user:read:broadcast user:read:email")
  end

  # you can pass options to the underlying http library via `opts` parameter
  def get_token!(params \\ [], headers \\ [], opts \\ []) do
    OAuth2.Client.get_token!(client(), params, headers, opts)
  end

  # Strategy Callbacks

  def authorize_url(client, params) do
    OAuth2.Strategy.AuthCode.authorize_url(client, params)
  end

  def get_token(client, params, headers) do
    client
    |> put_header("accept", "application/json")
    |> OAuth2.Strategy.AuthCode.get_token(params, headers)
  end

  def get_user(%{"user_login" => login}) do
    headers = [
      "Accept": "application/json",
      "Client-ID": Application.get_env(:stream_heda, StreamHeda.Twitch)[:client_id]
    ]

    "https://api.twitch.tv/helix/users?login=#{login}"
    |> HTTPoison.get(headers)
    |> case do
      {:ok, %HTTPoison.Response{status_code: code, body: raw_body}} ->
        {code, raw_body}
      {:error, %{reason: reason}} ->
        {:error, reason}
      end
    |> (fn {_ok, body} ->
      body
      |> Jason.decode!
      |> case do
        %{"data" => [%{"display_name" => name, "id" => id, "login" => login}]} ->
          %{display_name: name, id: id, login: login}
        _ ->
          {:error, "Error during JSON parsing"}
      end
    end).()
  end


  def get_user(%{access_token: token}) do
    headers = [
      "Accept": "application/json",
      "Client-ID": Application.get_env(:stream_heda, StreamHeda.Twitch)[:client_id],
      "Authorization": "Bearer #{token}"
    ]

    "https://api.twitch.tv/helix/users"
    |> HTTPoison.get(headers)
    |> case do
      {:ok, %HTTPoison.Response{status_code: code, body: raw_body}} ->
        {code, raw_body}
      {:error, %{reason: reason}} ->
        {:error, reason}
      end
    |> (fn {_ok, body} ->
      body
      |> Jason.decode!
      |> case do
        %{"data" => [%{"login" => login, "display_name" => name, "id" => id, "email" => email, "profile_image_url" => profile_image_url}]} ->
          %User{login: login, display_name: name, id: String.to_integer(id), email: email, profile_picture_url: profile_image_url }
        _ ->
        {:error, "Error during JSON parsing"}
      end
    end).()
  end

end
