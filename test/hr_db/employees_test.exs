defmodule HrDb.EmployeesTest do
  use HrDb.DataCase

  alias HrDb.Employees

  describe "employee" do
    alias HrDb.Employees.Employee

    import HrDb.EmployeesFixtures

    @invalid_attrs %{active: nil, address: nil, supervisor: nil, employee_id: nil, first_name: nil, last_name: nil, other_names: nil, email: nil, department: nil, job_title: nil, phone_number: nil, dob: nil, gender: nil, id_number: nil, salary: nil, kra: nil, shif: nil, nssf: nil, bank_account: nil}

    test "list_employee/0 returns all employee" do
      employee = employee_fixture()
      assert Employees.list_employee() == [employee]
    end

    test "get_employee!/1 returns the employee with given id" do
      employee = employee_fixture()
      assert Employees.get_employee!(employee.id) == employee
    end

    test "create_employee/1 with valid data creates a employee" do
      valid_attrs = %{active: "some active", address: "some address", supervisor: "some supervisor", employee_id: "some employee_id", first_name: "some first_name", last_name: "some last_name", other_names: "some other_names", email: "some email", department: "some department", job_title: "some job_title", phone_number: "some phone_number", dob: ~D[2025-01-27], gender: "some gender", id_number: "some id_number", salary: "some salary", kra: "some kra", shif: "some shif", nssf: "some nssf", bank_account: "some bank_account"}

      assert {:ok, %Employee{} = employee} = Employees.create_employee(valid_attrs)
      assert employee.active == "some active"
      assert employee.address == "some address"
      assert employee.supervisor == "some supervisor"
      assert employee.employee_id == "some employee_id"
      assert employee.first_name == "some first_name"
      assert employee.last_name == "some last_name"
      assert employee.other_names == "some other_names"
      assert employee.email == "some email"
      assert employee.department == "some department"
      assert employee.job_title == "some job_title"
      assert employee.phone_number == "some phone_number"
      assert employee.dob == ~D[2025-01-27]
      assert employee.gender == "some gender"
      assert employee.id_number == "some id_number"
      assert employee.salary == "some salary"
      assert employee.kra == "some kra"
      assert employee.shif == "some shif"
      assert employee.nssf == "some nssf"
      assert employee.bank_account == "some bank_account"
    end

    test "create_employee/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Employees.create_employee(@invalid_attrs)
    end

    test "update_employee/2 with valid data updates the employee" do
      employee = employee_fixture()
      update_attrs = %{active: "some updated active", address: "some updated address", supervisor: "some updated supervisor", employee_id: "some updated employee_id", first_name: "some updated first_name", last_name: "some updated last_name", other_names: "some updated other_names", email: "some updated email", department: "some updated department", job_title: "some updated job_title", phone_number: "some updated phone_number", dob: ~D[2025-01-28], gender: "some updated gender", id_number: "some updated id_number", salary: "some updated salary", kra: "some updated kra", shif: "some updated shif", nssf: "some updated nssf", bank_account: "some updated bank_account"}

      assert {:ok, %Employee{} = employee} = Employees.update_employee(employee, update_attrs)
      assert employee.active == "some updated active"
      assert employee.address == "some updated address"
      assert employee.supervisor == "some updated supervisor"
      assert employee.employee_id == "some updated employee_id"
      assert employee.first_name == "some updated first_name"
      assert employee.last_name == "some updated last_name"
      assert employee.other_names == "some updated other_names"
      assert employee.email == "some updated email"
      assert employee.department == "some updated department"
      assert employee.job_title == "some updated job_title"
      assert employee.phone_number == "some updated phone_number"
      assert employee.dob == ~D[2025-01-28]
      assert employee.gender == "some updated gender"
      assert employee.id_number == "some updated id_number"
      assert employee.salary == "some updated salary"
      assert employee.kra == "some updated kra"
      assert employee.shif == "some updated shif"
      assert employee.nssf == "some updated nssf"
      assert employee.bank_account == "some updated bank_account"
    end

    test "update_employee/2 with invalid data returns error changeset" do
      employee = employee_fixture()
      assert {:error, %Ecto.Changeset{}} = Employees.update_employee(employee, @invalid_attrs)
      assert employee == Employees.get_employee!(employee.id)
    end

    test "delete_employee/1 deletes the employee" do
      employee = employee_fixture()
      assert {:ok, %Employee{}} = Employees.delete_employee(employee)
      assert_raise Ecto.NoResultsError, fn -> Employees.get_employee!(employee.id) end
    end

    test "change_employee/1 returns a employee changeset" do
      employee = employee_fixture()
      assert %Ecto.Changeset{} = Employees.change_employee(employee)
    end
  end
end
