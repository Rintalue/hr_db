defmodule HrDb.Repo.Migrations.CreateJob do
  use Ecto.Migration

  def change do
    create table(:job) do
      add :job_id, :string
      add :title, :string
      add :department, :string
      add :active, :string

      timestamps(type: :utc_datetime)
    end
  end
end
