defmodule HrDb.Repo.Migrations.AddLeaveBalanceToEmployees do
  use Ecto.Migration

  def change do
    alter table(:employee) do
      add :leave_balance, :integer, default: 21  # Default to 21 if it's a fixed number of days per employee
    end
  end
end
