defmodule StreamHeda.Repo do
  use Ecto.Repo,
    otp_app: :stream_heda,
    adapter: Ecto.Adapters.Postgres
end
