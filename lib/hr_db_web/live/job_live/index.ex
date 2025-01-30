defmodule HrDbWeb.JobLive.Index do
  use HrDbWeb, :live_view_main

  alias HrDb.Jobs
  alias HrDb.Jobs.Job

  @impl true
  def mount(_params, _session, socket) do
    {:ok, stream(socket, :job_collection, Jobs.list_job())}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Job")
    |> assign(:job, Jobs.get_job!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Job")
    |> assign(:job, %Job{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Job")
    |> assign(:job, nil)
  end

  @impl true
  def handle_info({HrDbWeb.JobLive.FormComponent, {:saved, job}}, socket) do
    {:noreply, stream_insert(socket, :job_collection, job)}
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    job = Jobs.get_job!(id)
    {:ok, _} = Jobs.delete_job(job)

    {:noreply, stream_delete(socket, :job_collection, job)}
  end
end
