defmodule HrDb.EmployeesFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `HrDb.Employees` context.
  """

  @doc """
  Generate a employee.
  """
  def employee_fixture(attrs \\ %{}) do
    {:ok, employee} =
      attrs
      |> Enum.into(%{
        active: "some active",
        address: "some address",
        bank_account: "some bank_account",
        department: "some department",
        dob: ~D[2025-01-27],
        email: "some email",
        employee_id: "some employee_id",
        first_name: "some first_name",
        gender: "some gender",
        id_number: "some id_number",
        job_title: "some job_title",
        kra: "some kra",
        last_name: "some last_name",
        nssf: "some nssf",
        other_names: "some other_names",
        phone_number: "some phone_number",
        salary: "some salary",
        shif: "some shif",
        supervisor: "some supervisor"
      })
      |> HrDb.Employees.create_employee()

    employee
  end
end
