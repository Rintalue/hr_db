defmodule HrDb.Repo.Migrations.CreateEmployee do
  use Ecto.Migration

  def change do
    create table(:employee) do
      add :employee_id, :string
      add :first_name, :string
      add :last_name, :string
      add :other_names, :string
      add :email, :string
      add :department, :string
      add :job_title, :string
      add :phone_number, :string
      add :address, :string
      add :supervisor, :string
      add :dob, :date
      add :gender, :string
      add :id_number, :string
      add :salary, :string
      add :kra, :string
      add :shif, :string
      add :nssf, :string
      add :bank_account, :string
      add :active, :string

      timestamps(type: :utc_datetime)
    end
  end
end
