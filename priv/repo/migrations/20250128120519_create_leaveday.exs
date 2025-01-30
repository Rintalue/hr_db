defmodule HrDb.Repo.Migrations.CreateLeaveday do
  use Ecto.Migration

  def change do
    create table(:leaveday) do
      add :employee_id, :string
      add :first_name, :string
      add :last_name, :string
      add :email, :string
      add :phone_number, :string
      add :leave_days, :string
      add :start_date, :date
      add :end_date, :date
      add :reason, :string
      add :status, :string

      timestamps(type: :utc_datetime)
    end
  end
end
