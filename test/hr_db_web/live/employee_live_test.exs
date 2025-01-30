defmodule HrDbWeb.EmployeeLiveTest do
  use HrDbWeb.ConnCase

  import Phoenix.LiveViewTest
  import HrDb.EmployeesFixtures

  @create_attrs %{active: "some active", address: "some address", supervisor: "some supervisor", employee_id: "some employee_id", first_name: "some first_name", last_name: "some last_name", other_names: "some other_names", email: "some email", department: "some department", job_title: "some job_title", phone_number: "some phone_number", dob: "2025-01-27", gender: "some gender", id_number: "some id_number", salary: "some salary", kra: "some kra", shif: "some shif", nssf: "some nssf", bank_account: "some bank_account"}
  @update_attrs %{active: "some updated active", address: "some updated address", supervisor: "some updated supervisor", employee_id: "some updated employee_id", first_name: "some updated first_name", last_name: "some updated last_name", other_names: "some updated other_names", email: "some updated email", department: "some updated department", job_title: "some updated job_title", phone_number: "some updated phone_number", dob: "2025-01-28", gender: "some updated gender", id_number: "some updated id_number", salary: "some updated salary", kra: "some updated kra", shif: "some updated shif", nssf: "some updated nssf", bank_account: "some updated bank_account"}
  @invalid_attrs %{active: nil, address: nil, supervisor: nil, employee_id: nil, first_name: nil, last_name: nil, other_names: nil, email: nil, department: nil, job_title: nil, phone_number: nil, dob: nil, gender: nil, id_number: nil, salary: nil, kra: nil, shif: nil, nssf: nil, bank_account: nil}

  defp create_employee(_) do
    employee = employee_fixture()
    %{employee: employee}
  end

  describe "Index" do
    setup [:create_employee]

    test "lists all employee", %{conn: conn, employee: employee} do
      {:ok, _index_live, html} = live(conn, ~p"/employee")

      assert html =~ "Listing Employee"
      assert html =~ employee.active
    end

    test "saves new employee", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, ~p"/employee")

      assert index_live |> element("a", "New Employee") |> render_click() =~
               "New Employee"

      assert_patch(index_live, ~p"/employee/new")

      assert index_live
             |> form("#employee-form", employee: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert index_live
             |> form("#employee-form", employee: @create_attrs)
             |> render_submit()

      assert_patch(index_live, ~p"/employee")

      html = render(index_live)
      assert html =~ "Employee created successfully"
      assert html =~ "some active"
    end

    test "updates employee in listing", %{conn: conn, employee: employee} do
      {:ok, index_live, _html} = live(conn, ~p"/employee")

      assert index_live |> element("#employee-#{employee.id} a", "Edit") |> render_click() =~
               "Edit Employee"

      assert_patch(index_live, ~p"/employee/#{employee}/edit")

      assert index_live
             |> form("#employee-form", employee: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert index_live
             |> form("#employee-form", employee: @update_attrs)
             |> render_submit()

      assert_patch(index_live, ~p"/employee")

      html = render(index_live)
      assert html =~ "Employee updated successfully"
      assert html =~ "some updated active"
    end

    test "deletes employee in listing", %{conn: conn, employee: employee} do
      {:ok, index_live, _html} = live(conn, ~p"/employee")

      assert index_live |> element("#employee-#{employee.id} a", "Delete") |> render_click()
      refute has_element?(index_live, "#employee-#{employee.id}")
    end
  end

  describe "Show" do
    setup [:create_employee]

    test "displays employee", %{conn: conn, employee: employee} do
      {:ok, _show_live, html} = live(conn, ~p"/employee/#{employee}")

      assert html =~ "Show Employee"
      assert html =~ employee.active
    end

    test "updates employee within modal", %{conn: conn, employee: employee} do
      {:ok, show_live, _html} = live(conn, ~p"/employee/#{employee}")

      assert show_live |> element("a", "Edit") |> render_click() =~
               "Edit Employee"

      assert_patch(show_live, ~p"/employee/#{employee}/show/edit")

      assert show_live
             |> form("#employee-form", employee: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert show_live
             |> form("#employee-form", employee: @update_attrs)
             |> render_submit()

      assert_patch(show_live, ~p"/employee/#{employee}")

      html = render(show_live)
      assert html =~ "Employee updated successfully"
      assert html =~ "some updated active"
    end
  end
end
