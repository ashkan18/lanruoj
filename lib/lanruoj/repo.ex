defmodule Lanruoj.Repo do
  use Ecto.Repo,
    otp_app: :lanruoj,
    adapter: Ecto.Adapters.Postgres
end
