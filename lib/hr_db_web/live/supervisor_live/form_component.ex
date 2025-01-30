defmodule HrDbWeb.SupervisorLive.FormComponent do
  use HrDbWeb, :live_component

  alias HrDb.Supervisors

  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <.header>
        {@title}
        <:subtitle>Use this form to manage supervisor records in your database.</:subtitle>
      </.header>

      <.simple_form
        for={@form}
        id="supervisor-form"
        phx-target={@myself}
        phx-change="validate"
        phx-submit="save"
      >
        <.input field={@form[:supervisor_id]} type="text" label="Supervisor ID" />
        <.input field={@form[:supervisor_name]} type="text" label="Supervisor name" />
        <.input field={@form[:job_title]} type="select"  label="Choose Job Title" options={@jobs} prompt="choose job title" phx-change="job_title_changed" />
        <.input field={@form[:department]} type="text" label="Department" />

        <.input field={@form[:active]}
        type="checkbox"
        label="Active"
        value="true"
        prompt="Choose status" />

        <:actions>
          <.button phx-disable-with="Saving...">Save Supervisor</.button>
        </:actions>
      </.simple_form>
    </div>
    """
  end

  @impl true
  def update(%{supervisor: supervisor} = assigns, socket) do
    jobs = HrDb.Jobs.list_job()
    job_options = Enum.map(jobs, fn job-> {job.title, job.title} end)

    department = supervisor.department
    {:ok,
     socket
     |> assign(assigns)
     |> assign(:jobs, job_options)
     |> assign(:department, department)
     |> assign_new(:form, fn ->
       to_form(Supervisors.change_supervisor(supervisor))
     end)}
  end

  @impl true
  def handle_event("validate", %{"supervisor" => supervisor_params}, socket) do
    changeset = Supervisors.change_supervisor(socket.assigns.supervisor, supervisor_params)
    {:noreply, assign(socket, form: to_form(changeset, action: :validate))}
  end

  def handle_event("save", %{"supervisor" => supervisor_params}, socket) do
    save_supervisor(socket, socket.assigns.action, supervisor_params)
  end

  def handle_event("job_title_changed", %{"supervisor" => %{"job_title" => job_title}}, socket) do
    case HrDb.Jobs.get_job_by_title(job_title) do
      nil -> {:noreply, socket} # Handle missing job
      job ->
        department = job.department
        changeset = socket.assigns.form.source
                    |> Ecto.Changeset.change(%{department: department})

        {:noreply, assign(socket, form: to_form(changeset))}
    end
  end


  defp save_supervisor(socket, :edit, supervisor_params) do
    case Supervisors.update_supervisor(socket.assigns.supervisor, supervisor_params) do
      {:ok, supervisor} ->
        notify_parent({:saved, supervisor})

        {:noreply,
         socket
         |> put_flash(:info, "Supervisor updated successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, form: to_form(changeset))}
    end
  end

  defp save_supervisor(socket, :new, supervisor_params) do
    case Supervisors.create_supervisor(supervisor_params) do
      {:ok, supervisor} ->
        notify_parent({:saved, supervisor})

        {:noreply,
         socket
         |> put_flash(:info, "Supervisor created successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, form: to_form(changeset))}
    end
  end

  defp notify_parent(msg), do: send(self(), {__MODULE__, msg})
end
