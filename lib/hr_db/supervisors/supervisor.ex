defmodule HrDb.Supervisors.Supervisor do
  use Ecto.Schema
  import Ecto.Changeset

  schema "supervisor" do
    field :active, :string
    field :supervisor_id, :string
    field :supervisor_name, :string
    field :department, :string
    field :job_title, :string

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(supervisor, attrs) do
    supervisor
    |> cast(attrs, [:supervisor_id, :supervisor_name, :department, :active, :job_title])
    |> validate_required([:supervisor_id, :supervisor_name, :department, :active])
  end
end
