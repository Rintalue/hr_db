defmodule HrDbWeb.SupervisorLive.Index do
  use HrDbWeb, :live_view_main

  alias HrDb.Supervisors
  alias HrDb.Supervisors.Supervisor

  @impl true
  def mount(_params, _session, socket) do
    {:ok, stream(socket, :supervisor_collection, Supervisors.list_supervisor())}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Supervisor")
    |> assign(:supervisor, Supervisors.get_supervisor!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Supervisor")
    |> assign(:supervisor, %Supervisor{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Supervisor")
    |> assign(:supervisor, nil)
  end

  @impl true
  def handle_info({HrDbWeb.SupervisorLive.FormComponent, {:saved, supervisor}}, socket) do
    {:noreply, stream_insert(socket, :supervisor_collection, supervisor)}
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    supervisor = Supervisors.get_supervisor!(id)
    {:ok, _} = Supervisors.delete_supervisor(supervisor)

    {:noreply, stream_delete(socket, :supervisor_collection, supervisor)}
  end
end
