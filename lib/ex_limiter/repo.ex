defmodule ExLimiter.Repo do
  use Ecto.Repo,
    otp_app: :ex_limiter,
    adapter: Ecto.Adapters.SQLite3
end
