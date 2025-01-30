defmodule HrDbWeb.EmployeeLive.Index do
  use HrDbWeb, :live_view_main

  alias HrDb.Employees
  alias HrDb.Employees.Employee

  @impl true
  def mount(_params, _session, socket) do
    {:ok, stream(socket, :employee_collection, Employees.list_employee())}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Employee")
    |> assign(:employee, Employees.get_employee!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Employee")
    |> assign(:employee, %Employee{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Employee")
    |> assign(:employee, nil)
  end

  @impl true
  def handle_info({HrDbWeb.EmployeeLive.FormComponent, {:saved, employee}}, socket) do
    {:noreply, stream_insert(socket, :employee_collection, employee)}
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    employee = Employees.get_employee!(id)
    {:ok, _} = Employees.delete_employee(employee)

    {:noreply, stream_delete(socket, :employee_collection, employee)}
  end
end
