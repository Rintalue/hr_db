defmodule HrDb.Jobs.Job do
  use Ecto.Schema
  import Ecto.Changeset

  schema "job" do
    field :active, :string
    field :title, :string
    field :job_id, :string
    field :department, :string

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(job, attrs) do
    job
    |> cast(attrs, [:job_id, :title, :department, :active])
    |> validate_required([:job_id, :title, :department, :active])
  end
end
