defmodule HrDbWeb.LeavedayLive.Show do
  use HrDbWeb, :live_view_main

  alias HrDb.Leavedays

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(%{"id" => id}, _, socket) do
    {:noreply,
     socket
     |> assign(:page_title, page_title(socket.assigns.live_action))
     |> assign(:leaveday, Leavedays.get_leaveday!(id))}
  end

  defp page_title(:show), do: "Show Leaveday"
  defp page_title(:edit), do: "Edit Leaveday"
end
