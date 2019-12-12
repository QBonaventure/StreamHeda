defmodule StreamHedaWeb.Live.Components.SHI do
  use Phoenix.LiveComponent
  use Ecto.Schema
  import Ecto.Changeset

  schema "ledcolor" do
    field :color_code
  end

  def get_query([r, g, b]) do
    remote_endpoint = Application.get_env(:shi, :led_controller)[:remote_endpoint]
    "http://#{remote_endpoint}/event_triggered?type=usercolor&r=#{r}&g=#{g}&b=#{b}"
  end


  def render(assigns) do
    changeset = color_changeset(%StreamHedaWeb.Live.Components.SHI{}, assigns.led_color)
    StreamHedaWeb.ShiView.render("controller.html", led_color: changeset)
  end


  def hex_to_rgb(value) do
      value
      |> String.slice(1..-1)
      |> slice_hex_code
      |> Enum.map(fn(code) -> hex_to_int(code) end)
      |> max_out_values
  end


  def max_out_values(values) do
    coeff = 255/Enum.max(values)
    minValue = Enum.min(values)
    for value <- values do
      cond do
        value == minValue -> 0
        value != minValue -> coeff*value |> Float.ceil |> round
      end
    end
  end


  def hex_to_int(value) do
    value
      |> to_charlist
      |> List.to_integer(16)
  end


  def slice_hex_code(string) do
    for <<x::binary-2 <- string>>, do: x
  end


  def handle_event("shi-led-color", value, socket) do
    hex_to_rgb(value["shi"]["color_code"])
    |> get_query
    |> HTTPoison.get

    {:noreply, socket}
  end


  def color_changeset(color, params \\ %{}) do
    color
    |> cast(params, [:color_code])
  end

end
