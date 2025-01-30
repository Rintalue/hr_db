defmodule HrDb.Repo do
  use Ecto.Repo,
    otp_app: :hr_db,
    adapter: Ecto.Adapters.MyXQL

end
