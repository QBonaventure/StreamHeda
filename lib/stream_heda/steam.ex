defmodule StreamHeda.Steam do
  alias OpenIDConnect


  def app_key do
    Application.get_env(:stream_heda, StreamHeda.Steam)[:client_key]
  end


  def authorize_url do
    OpenIDConnect.authorization_uri(:steam)
  end



  def get_logo_url(appid, filename) do
    appid = Integer.to_string(appid)
    "https://steamcdn-a.akamaihd.net/steamcommunity/public/images/apps/#{appid}/#{filename}.jpg"
  end


  def get_game_url(%{"appid" => game_id}) do
    "https://store.steampowered.com/app/#{game_id}"
  end

  def get_playtime(%{"playtime_forever" => playtime}) do
    playtime/60
    |> Float.ceil(2)
  end


  def get_games_list(%StreamHeda.User{steam_id: steam_id}) do
    query_string_map = %{
        "key" => app_key(),
        "steamid" => steam_id,
        "include_played_free_games" => 1,
        "include_appinfo" => 1,
        "format" => "json",
      }

    "https://api.steampowered.com/IPlayerService/GetOwnedGames/v0001/?" <> URI.encode_query(query_string_map)
    |> HTTPoison.get
    |> case do
      {:ok, %HTTPoison.Response{status_code: 200, body: raw_body}} ->
        raw_body
        |> Jason.decode!
        |> case do
          %{"response" => %{"games" => games}} ->
            games = Enum.map(games, fn (map) ->
              Map.take(map, ["name", "appid", "playtime_forever", "img_logo_url"])
              |> Map.put("img_logo_url", get_logo_url(map["appid"], map["img_logo_url"]))
             end)
            {:ok, games}
          %{} ->
            {:error, :no_steam_id}
          _ ->
            {:error, :json_parsing_error}
        end
      {:ok, %HTTPoison.Response{status_code: 500}} ->
        {:error, :internal_server_error}
      {:error, %{reason: reason}} ->
        {:error, reason}
      end
  end

end
