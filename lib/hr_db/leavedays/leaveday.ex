defmodule HrDb.Leavedays.Leaveday do
  use Ecto.Schema
  import Ecto.Changeset

  schema "leaveday" do
    field :reason, :string
    field :leave_type, :string
    field :employee_id, :string
    field :name, :string
    field :phone_number, :string
    field :leave_days, :string
    field :start_date, :date
    field :end_date, :date
    field :status, :string

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(leaveday, attrs) do
    leaveday
    |> cast(attrs, [:employee_id, :name, :phone_number, :leave_days, :start_date, :end_date, :reason, :leave_type,:status])
    |> validate_required([:employee_id,  :leave_days, :start_date, :end_date, :reason, :leave_type])
  end
end
