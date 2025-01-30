defmodule HrDb.Repo.Migrations.CreateSupervisor do
  use Ecto.Migration

  def change do
    create table(:supervisor) do
      add :supervisor_id, :string
      add :supervisor_name, :string
      add :department, :string
      add :active, :string

      timestamps(type: :utc_datetime)
    end
  end
end
