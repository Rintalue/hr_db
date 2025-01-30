defmodule HrDbWeb.LeavedayLive.Index do
  use HrDbWeb, :live_view_main

  alias HrDb.Leavedays
  alias HrDb.Leavedays.Leaveday

  @impl true
  def mount(_params, _session, socket) do
    {:ok, stream(socket, :leaveday_collection, Leavedays.list_leaveday())}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Leaveday")
    |> assign(:leaveday, Leavedays.get_leaveday!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Leaveday")
    |> assign(:leaveday, %Leaveday{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Leaveday")
    |> assign(:leaveday, nil)
  end

  @impl true
  def handle_info({HrDbWeb.LeavedayLive.FormComponent, {:saved, leaveday}}, socket) do
    {:noreply, stream_insert(socket, :leaveday_collection, leaveday)}
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    leaveday = Leavedays.get_leaveday!(id)
    {:ok, _} = Leavedays.delete_leaveday(leaveday)

    {:noreply, stream_delete(socket, :leaveday_collection, leaveday)}
  end
end
