defmodule HrDbWeb.EmployeeLive.Show do
  use HrDbWeb, :live_view_main

  alias HrDb.Employees

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(%{"id" => id}, _, socket) do
    {:noreply,
     socket
     |> assign(:page_title, page_title(socket.assigns.live_action))
     |> assign(:employee, Employees.get_employee!(id))}
  end

  defp page_title(:show), do: "Show Employee"
  defp page_title(:edit), do: "Edit Employee"
end
