defmodule HrDb.Employees.Employee do
  use Ecto.Schema
  import Ecto.Changeset

  schema "employee" do
    field :active, :string
    field :address, :string
    field :supervisor, :string
    field :image, :string
    field :employee_id, :string
    field :first_name, :string
    field :last_name, :string
    field :other_names, :string
    field :email, :string
    field :department, :string
    field :job_title, :string
    field :phone_number, :string
    field :dob, :date
    field :gender, :string
    field :id_number, :string
    field :salary, :string
    field :kra, :string
    field :shif, :string
    field :nssf, :string
    field :bank_account, :string
    field :leave_balance, :integer



    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(employee, attrs) do
    employee
    |> cast(attrs, [:employee_id, :first_name, :last_name, :other_names, :email, :department, :job_title, :phone_number, :address, :supervisor, :dob, :gender, :id_number, :salary,:image, :kra, :shif, :nssf, :bank_account, :active, :leave_balance])
    |> validate_required([:employee_id, :first_name, :last_name, :email, :department, :job_title, :phone_number, :address,:dob, :gender, :id_number, :salary, :kra, :shif, :nssf, :bank_account, :active])
  end
end
