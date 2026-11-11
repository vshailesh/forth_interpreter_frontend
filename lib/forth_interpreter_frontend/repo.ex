defmodule ForthInterpreterFrontend.Repo do
  use Ecto.Repo,
    otp_app: :forth_interpreter_frontend,
    adapter: Ecto.Adapters.Postgres
end
